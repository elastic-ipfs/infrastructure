terraform {
  backend "s3" {
    profile        = "ipfs"
    bucket         = "ipfs-aws-terraform-state"
    dynamodb_table = "ipfs-aws-terraform-state-lock"
    region         = "us-west-2"
    key            = "terraform.peer.tfstate"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }


    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
  }

  required_version = ">= 1.0.0"
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = "ipfs-aws-terraform-state"
    key    = "terraform.shared.tfstate"
    region = "${local.region}"
  }
}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

provider "aws" {
  profile = "ipfs"
  region  = local.region
  default_tags {
    tags = {
      Team        = "NearForm"
      Project     = "AWS-IPFS"
      Environment = "POC"
      Subsystem   = "Peer"
      ManagedBy   = "Terraform"
    }
  }
}

data "aws_availability_zones" "available" {
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name                 = var.vpc.name
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"] # Worker Nodes
  public_subnets       = ["10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24"]                # LoadBalancer and NAT
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }
}

resource "aws_s3_bucket" "ipfs-peer-bitswap-config" {
  bucket = var.peerConfigBucketName
  acl    = "private"
}

resource "aws_s3_bucket" "ipfs-peer-ads" {
  bucket = var.ipfsProviderAds
  acl    = "private"
}

module "gateway-endpoint-to-s3-dynamo" {
  source         = "../modules/gateway-endpoint-to-s3-dynamo"
  vpc_id         = module.vpc.vpc_id
  region         = local.region
  route_table_id = module.vpc.private_route_table_ids[0]
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  vpc_id                          = module.vpc.vpc_id
  subnets                         = [module.vpc.private_subnets[0], module.vpc.private_subnets[2]]
  fargate_subnets                 = [module.vpc.private_subnets[2], module.vpc.private_subnets[3]]
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  enable_irsa                     = true # To be able to access AWS services from PODs  
  node_groups = {                        # Needed for CoreDNS (https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html)
    test-ipfs-aws-peer-subsystem = {
      name             = "test-ipfs-aws-peer-subsystem-node-group"
      desired_capacity = 2
      min_size         = 2
      max_size         = 4

      instance_types = ["t3.large"]
      k8s_labels = {
        workerType = "managed_ec2_node_groups"
      }
      update_config = {
        max_unavailable_percentage = 50
      }
    }
  }
  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "default"
          labels = {
            workerType = "fargate"
          }
        }
      ]
      timeouts = {
        create = "5m"
        delete = "5m"
      }
    }
  }
  # TODO: Solve error when trying to manage_aws_auth. Is trying to always post to "http://localhost/api/v1/namespaces/kube-system/configmaps":
  manage_aws_auth = false
  # map_users = [
  #   {
  #     userarn  = "arn:aws:iam::505595374361:user/francisco",
  #     username = "francisco",
  #     groups   = ["system:masters"]
  #   }
  # ]
  kubeconfig_aws_authenticator_command      = "aws"
  kubeconfig_aws_authenticator_command_args = ["eks", "get-token", "--cluster-name", var.cluster_name]
  kubeconfig_output_path                    = var.kubeconfig_output_path
  # cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"] # Enable for loging
}

module "kube-specs" {
  source = "../modules/kube-specs"
  aws_iam_role_policy_list = [
    data.terraform_remote_state.shared.outputs.dynamodb_blocks_policy,
    data.terraform_remote_state.shared.outputs.s3_policy_read,
    data.terraform_remote_state.shared.outputs.s3_policy_write,
    aws_iam_policy.config_peer_s3_bucket_policy_read, # Remember to manually add this file after infra is up running (403 error otherwise)
  ]
  cluster_oidc_issuer_url   = module.eks.cluster_oidc_issuer_url
  cluster_oidc_provider_arn = module.eks.oidc_provider_arn
  cluster_id            = module.eks.cluster_id
  container_image           = var.container_image
  peerConfigBucketName      = var.peerConfigBucketName
  kubeconfig_output_path    = module.eks.kubeconfig_filename
  host                      = data.aws_eks_cluster.eks.endpoint
  token                     = data.aws_eks_cluster_auth.eks.token
  cluster_ca_certificate    = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
}

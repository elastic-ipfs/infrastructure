terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
  profile = var.profile
  region  = var.region
  default_tags {
    tags = {
      Team       = "NearForm"
      Project    = "AWS-IPFS"
      ManagedBy  = "Terraform"
      Example    = "true"
      Production = "false"
    }
  }
}

data "aws_availability_zones" "available" {
}
data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name                 = var.vpc.name
  cidr                 = "10.4.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.4.1.0/24", "10.4.2.0/24"]
  public_subnets       = ["10.4.3.0/24", "10.4.4.0/24", "10.4.5.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "terraform/example"                         = "true"
    "Production"                                = "false"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "terraform/example"                         = "true"
    "Production"                                = "false"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "17.24.0" # TODO: Upgrade
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  vpc_id                          = module.vpc.vpc_id
  subnets                         = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  enable_irsa                     = true # To be able to access AWS services from PODs  

  node_groups = {
    test-ipfs-aws-peer-subsystem = {
      name             = "testerrates-ipfs-peer-subsystem-node-group"
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

  manage_aws_auth = false
}

resource "aws_s3_bucket" "ipfs-peer-bitswap-config" {
  bucket = var.config_bucket_name
  acl    = "private"
}

resource "aws_s3_bucket" "ipfs-peer-ads" {
  bucket = var.provider_ads_bucket_name
  acl    = "public-read"
}

module "kube-base-components" {
  source                  = "../"
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  cluster_id              = module.eks.cluster_id
  config_bucket_name      = var.config_bucket_name
  kubeconfig_output_path  = module.eks.kubeconfig_filename
  host                    = data.aws_eks_cluster.eks.endpoint
  token                   = data.aws_eks_cluster_auth.eks.token
  cluster_ca_certificate  = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  service_account_roles = {
    "bitwsap_peer_subsystem_role" = {
      service_account_name      = "bitswap-irsa",
      service_account_namespace = "default",
      role_name                 = "bitwsap_peer_subsystem_role",
      policies_list = [
        aws_iam_policy.config_peer_s3_bucket_policy_read
      ]
    },
    provider_peer_subsystem_role = {
      service_account_name      = "provider-irsa",
      service_account_namespace = "default",
      role_name                 = "provider_peer_subsystem_role",
      policies_list = [
        aws_iam_policy.ads_s3_bucket_policy_read,
        aws_iam_policy.ads_s3_bucket_policy_write
      ]
    },
  }
}


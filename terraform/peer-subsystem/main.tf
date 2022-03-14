terraform {
  backend "s3" {
    profile        = "ipfs"
    bucket         = "ipfs-elastic-provider-terraform-state"
    dynamodb_table = "ipfs-elastic-provider-terraform-state-lock"
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
      version = "~> 2.4.1"
    }
  }

  required_version = ">= 1.0.0"
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = "ipfs-elastic-provider-terraform-state"
    key    = "terraform.shared.tfstate"
    region = "${var.region}"
  }
}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

provider "aws" {
  profile = var.profile
  region  = var.region
  default_tags {
    tags = {
      Team        = "NearForm"
      Project     = "IPFS-Elastic-Provider"
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
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

module "gateway-endpoint-to-s3-dynamo" {
  source         = "../modules/gateway-endpoint-to-s3-dynamo"
  vpc_id         = module.vpc.vpc_id
  region         = var.region
  route_table_id = module.vpc.private_route_table_ids[0]
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

module "eks" {
  source                             = "terraform-aws-modules/eks/aws"
  version                            = "~> 18.2.0"
  cluster_name                       = var.cluster_name
  cluster_version                    = var.cluster_version
  cluster_endpoint_private_access    = true
  cluster_endpoint_public_access     = true
  vpc_id                             = module.vpc.vpc_id
  subnet_ids                         = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  enable_irsa                        = true # To be able to access AWS services from PODs  
  cluster_security_group_description = "EKS cluster security group - Control Plane"

  cluster_endpoint_public_access_cidrs = [ # TODO: Access through AWS transit gateway
    "${chomp(data.http.myip.body)}/32",    # GitHub Actions Self Runner Static IP 
    "177.33.141.81/32",
    "185.152.47.29/32",
  ]

  eks_managed_node_groups = { # Needed for CoreDNS (https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html)
    test-ipfs-peer-subsys = {
      name         = var.cluster_name
      desired_size = 2
      min_size     = 1
      max_size     = 4

      instance_types = ["t3.large"]
      k8s_labels = {
        workerType = "managed_ec2_node_groups"
      }
      update_config = {
        max_unavailable_percentage = 50
      }

      tags = { # This is also applied to IAM role.
        "eks/${var.accountId}/${var.cluster_name}/type" : "node"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" : "owned"
        "k8s.io/cluster-autoscaler/enabled" : "TRUE"
      }
    }
  }

  node_security_group_additional_rules = local.node_security_group_additional_rules

  fargate_profiles = {
    default = {
      name       = "default"
      subnet_ids = [module.vpc.private_subnets[2], module.vpc.private_subnets[3]]
      selectors = [
        {
          namespace = "default"
          labels = {
            workerType = "fargate"
          }
        }
      ]

      tags = { # This is also applied to IAM role.
        "eks/${var.accountId}/${var.cluster_name}/type" : "fargateNode"
      }
      timeouts = {
        create = "5m"
        delete = "5m"
      }
    }
  }
}

resource "aws_security_group_rule" "fargate_ingress" {
  description              = "Node to cluster - Fargate kubelet (Required for Metrics Server)"
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  source_security_group_id = module.eks.node_security_group_id
  security_group_id        = module.eks.cluster_primary_security_group_id
}


resource "aws_security_group_rule" "fargate_egress" {
  description              = "Node to cluster - Fargate kubelet (Required for Metrics Server)"
  protocol                 = "tcp"
  from_port                = 10250
  to_port                  = 10250
  type                     = "egress"
  source_security_group_id = module.eks.cluster_primary_security_group_id
  security_group_id        = module.eks.node_security_group_id
}

resource "aws_security_group_rule" "dns_ingress_tcp" {
  description              = "Fargate to DNS (TCP)"
  type                     = "ingress"
  from_port                = 53
  to_port                  = 53
  protocol                 = "tcp"
  source_security_group_id = module.eks.cluster_primary_security_group_id
  security_group_id        = module.eks.node_security_group_id
}

resource "aws_security_group_rule" "dns_ingress_udp" {
  description              = "Fargate to DNS (UDP)"
  type                     = "ingress"
  from_port                = 53
  to_port                  = 53
  protocol                 = "udp"
  source_security_group_id = module.eks.cluster_primary_security_group_id
  security_group_id        = module.eks.node_security_group_id
}


module "kube-base-components" {
  source                  = "../modules/kube-base-components"
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  cluster_id              = module.eks.cluster_id
  region                  = var.region
  config_bucket_name      = data.terraform_remote_state.shared.outputs.ipfs_peer_bitswap_config_bucket.id
  host                    = data.aws_eks_cluster.eks.endpoint
  token                   = data.aws_eks_cluster_auth.eks.token
  cluster_ca_certificate  = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  service_account_roles = {
    "bitswap_peer_subsystem_role" = {
      service_account_name      = "bitswap-irsa",
      service_account_namespace = "bitswap-peer",
      role_name                 = "bitswap_peer_subsystem_role",
      policies_list = [
        data.terraform_remote_state.shared.outputs.dynamodb_blocks_policy,
        data.terraform_remote_state.shared.outputs.s3_cars_policy_read,
        data.terraform_remote_state.shared.outputs.s3_cars_policy_write,
        data.terraform_remote_state.shared.outputs.sqs_multihashes_policy_send,
        data.terraform_remote_state.shared.outputs.s3_config_peer_bucket_policy_read,
      ]
    },
  }
}

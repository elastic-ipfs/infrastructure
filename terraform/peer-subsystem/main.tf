terraform {
  backend "s3" {
    profile        = "default"
    bucket         = "test-ipfs-aws-state" # TODO: Remove test prefix when moving to official account
    dynamodb_table = "test-ipfs-aws-state-lock"
    region         = "us-west-2"
    key            = "terraform.peer.tfstate"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

locals {
  tags = {
    Team        = "NearForm"
    Project     = "AWS-IPFS"
    Environment = "POC"
    Subsystem   = "Peer"
    ManagedBy   = "Terraform"
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
  default_tags {
    tags = local.tags
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
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"] # TODO: What if I disable that? Will it loose connection with data plane? Can it be replaced by a private endpoint?
  enable_nat_gateway   = true                                          # TODO: What if I disable that? Will it loose connection with data plane? Can it be replaced by a private endpoint?
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks-cluster.name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks-cluster.name}" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = var.eks-cluster.name
  cluster_version = var.eks-cluster.version

  vpc_id          = module.vpc.vpc_id
  subnets         = [module.vpc.private_subnets[0], module.vpc.public_subnets[1]]
  fargate_subnets = [module.vpc.private_subnets[2]]

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # You require a node group to schedule coredns which is critical for running correctly internal DNS.
  # If you want to use only fargate you must follow docs `(Optional) Update CoreDNS`
  # available under https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html
  node_groups = {
    test-ipfs-aws-peer-subsystem = {
      name             = "test-ipfs-aws-peer-subsystem-node-group"
      desired_capacity = 2
      min_size = 2
      max_size = 4

      instance_types = ["t3.large"]
      k8s_labels = {
        Example    = "managed_node_groups"
        GithubRepo = "terraform-aws-eks"
        GithubOrg  = "terraform-aws-modules"
      }
      # additional_tags = {
      #   ExtraTag = "example"
      # }
      update_config = {
        max_unavailable_percentage = 50 # or set `max_unavailable`
      }
    }
  }

  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            k8s-app = "kube-dns"
          }
        },
        {
          namespace = "default"
          labels = {
            WorkerType = "fargate"
          }
        }
      ]

      tags = {
        Owner = "default"
      }

      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }

    secondary = { # TODO: Test that label selector part. What happens with deployments that don't have those labels? Later, remove labels that don't make any sense. 
      // There is already label WorkerType = fargete at the default selector list. Do I really need this secondary?
      name = "secondary"
      selectors = [
        {
          namespace = "default"
          labels = {
            Environment = "test"
            GithubRepo  = "terraform-aws-eks"
            GithubOrg   = "terraform-aws-modules"
          }
        }
      ]

      # Using specific subnets instead of the ones configured in EKS (`subnets` and `fargate_subnets`)
      subnets = [module.vpc.private_subnets[1]]

      tags = {
        Owner = "secondary"
      }
    }
  }

  manage_aws_auth = false
}

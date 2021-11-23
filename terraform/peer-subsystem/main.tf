terraform {
  backend "s3" {
    profile = "default"
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

provider "aws" {
  profile = "default"
  region  = "us-west-2"
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
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"] # TODO: What if I disable that? Will it loose connection with data plane? Can it be replaced by a private endpoint?
  enable_nat_gateway   = true # TODO: What if I disable that? Will it loose connection with data plane? Can it be replaced by a private endpoint?
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks-cluster.name}" = "shared"
    "kubernetes.io/role/elb"              = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks-cluster.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = "1"
  }
}

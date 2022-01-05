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

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name                 = var.vpc.name
  cidr                 = "10.3.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.3.1.0/24", "10.3.2.0/24"] 
  enable_dns_hostnames = true
}

module "gateway-endpoint-to-s3-dynamo" {
  source         = "../"
  vpc_id         = module.vpc.vpc_id
  region         = var.region
  route_table_id = module.vpc.private_route_table_ids[0]
}

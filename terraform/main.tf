terraform {
  backend "s3" {
    bucket         = "test-ipfs-aws-cars-state"
    dynamodb_table = "test-ipfs-aws-cars-state-lock"
    region         = "us-west-2"
    key            = "terraform.tfstate"
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
  region  = "us-east-2"
  default_tags {
    tags = {
      Team        = "NearForm"
      Project     = "AWS-IPFS"
      Environment = "POC"
      ManagedBy   = "Terraform"
    }
  }
}

module "indexing-subsystem" {
  source         = "./modules/indexing-subsystem"
  carsBucketName = var.carsBucketName
}

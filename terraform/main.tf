terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

module "indexing-subsystem" {
  source = "./modules/indexing-subsystem"
  carsBucketName = var.carsBucketName
}

terraform {
  backend "s3" {
    profile = "ipfs"
    bucket         = "ipfs-aws-terraform-state"
    dynamodb_table = "ipfs-aws-terraform-state-lock"
    region         = "us-west-2"
    key            = "terraform.shared.tfstate"
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
  profile = "ipfs"
  region  = "us-west-2"
  default_tags {
    tags = {
      Team        = "NearForm"
      Project     = "AWS-IPFS"
      Environment = "POC"
      Subsystem   = "Shared"
      ManagedBy   = "Terraform"
    }
  }
}

resource "aws_s3_bucket" "cars" {
  bucket = var.carsBucketName
  acl    = "private"
  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }  
}

resource "aws_sqs_queue" "publishing_queue" {
  name                      = "publishing"
  receive_wait_time_seconds = 10
}

module "dynamodb" {
  source = "../modules/dynamodb"
}
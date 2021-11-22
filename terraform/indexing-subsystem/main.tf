terraform {
  backend "s3" {
    bucket         = "test-ipfs-aws-cars-state"
    dynamodb_table = "test-ipfs-aws-cars-state-lock"
    region         = "us-west-2"
    key            = "terraform.indexing.tfstate"
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
      Subsystem   = "Indexing"
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

module "api-gateway-to-s3" {
  source = "../modules/api-gateway-to-s3"
  bucketName = var.carsBucketName
}

module "lambda-from-s3" {
  source = "../modules/lambda-from-s3"
  bucket = aws_s3_bucket.cars
}

module "dynamodb" {
  source = "../modules/dynamodb"
  lambdaRoleName=module.lambda-from-s3.lambdaRoleName # TODO: Will this become a list of allowed roles?
}

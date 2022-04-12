terraform {
  backend "s3" {
    profile        = "ipfs"
    bucket         = "ipfs-elastic-provider-terraform-state"
    dynamodb_table = "ipfs-elastic-provider-terraform-state-lock"
    region         = "us-west-2"
    key            = "terraform.bucket-to-indexer.tfstate"
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

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = "ipfs-elastic-provider-terraform-state"
    key    = "terraform.shared.tfstate"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "indexing" {
  backend = "s3"
  config = {
    bucket = "ipfs-elastic-provider-terraform-state"
    key    = "terraform.indexing.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
  default_tags {
    tags = {
      Team        = "NearForm"
      Project     = "IPFS-Elastic-Provider"
      Environment = "POC"
      Subsystem   = "Indexing"
      ManagedBy   = "Terraform"
    }
  }
}

module "lambda-from-s3" {
  source                    = "../modules/lambda-from-s3"
  lambda_name               = var.lambda_name
  lambda_memory             = var.lambda_memory
  lambda_timeout            = var.lambda_timeout
  bucket                    = var.bucket
  topic_url                 = data.terraform_remote_state.indexing.outputs.sqs_indexer_topic.url
  region                    = var.region
  lambda_image              = var.lambda_image
  
  aws_iam_role_policy_list = [
    data.terraform_remote_state.shared.outputs.dynamodb_blocks_policy,
    data.terraform_remote_state.shared.outputs.dynamodb_car_policy,
    # data.terraform_remote_state.indexing.outputs.sqs_indexer_policy_send
  ]
  custom_metrics = [
  ]
}

resource "aws_ecr_repository" "ecr-repo-bucket-to-indexer-lambda" {
  name = "bucket-to-indexer-lambda"
}
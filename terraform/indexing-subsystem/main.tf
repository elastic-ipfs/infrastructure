terraform {
  backend "s3" {
    profile        = "ipfs"
    bucket         = "ipfs-aws-terraform-state"
    dynamodb_table = "ipfs-aws-terraform-state-lock"
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

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = "ipfs-aws-terraform-state"
    key    = "terraform.shared.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  profile = "ipfs"
  region  = "us-west-2"
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

module "api-gateway-to-s3" {
  source = "../modules/api-gateway-to-s3"
  bucket = data.terraform_remote_state.shared.outputs.cars_bucket
  aws_iam_role_policy_list = [
     data.terraform_remote_state.shared.outputs.s3_policy_write,
  ]
}

module "lambda-from-s3" {
  source = "../modules/lambda-from-s3"
  bucket = data.terraform_remote_state.shared.outputs.cars_bucket
  aws_iam_role_policy_list = [
    data.terraform_remote_state.shared.outputs.s3_policy_read,
    data.terraform_remote_state.shared.outputs.s3_policy_write,
    data.terraform_remote_state.shared.outputs.dynamodb_cid_policy,
    data.terraform_remote_state.shared.outputs.dynamodb_car_policy
  ]
}

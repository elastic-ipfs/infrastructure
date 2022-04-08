terraform {
  backend "s3" {
    profile        = "ipfs"
    bucket         = "ipfs-elastic-provider-terraform-state"
    dynamodb_table = "ipfs-elastic-provider-terraform-state-lock"
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
    bucket = "ipfs-elastic-provider-terraform-state"
    key    = "terraform.shared.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "indexing" {
  backend = "s3"
  config = {
    bucket = "ipfs-elastic-provider-terraform-state"
    key    = "terraform.indexing.tfstate"
    region = var.region
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
  lambdaName                = "bucket-to-indexer"
  bucket                    = var.bucket
  topic_url                 = data.terraform_remote_state.shared.outputs.sqs_indexer_topic.aws_sqs_queue.indexer_topic.url
  region                    = var.region
  aws_iam_role_policy_list = [
    data.terraform_remote_state.shared.outputs.s3_cars_policy_read,
    data.terraform_remote_state.shared.outputs.s3_cars_policy_write,
    data.terraform_remote_state.shared.outputs.dynamodb_blocks_policy,
    data.terraform_remote_state.shared.outputs.dynamodb_car_policy,
    data.terraform_remote_state.indexing.outputs.sqs_notifications_policy_send
  ]
  custom_metrics = [
    "s3-fetchs-count",
    "dynamo-creates-count",
    "dynamo-updates-count",
    "dynamo-deletes-count",
    "dynamo-reads-count",
    "sqs-publishes-count"
  ]
}
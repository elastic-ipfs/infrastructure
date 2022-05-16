terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

data "terraform_remote_state" "indexing" {
  backend = "s3"
  config = {
    bucket = "ipfs-elastic-provider-terraform-state"
    key    = "terraform.indexing.tfstate"
    region = var.indexing_stack_region
  }
}

module "lambda_from_s3" {
  source = "../../modules/lambda-from-s3"
  bucket = var.bucket
  lambda = {
    image_uri   = local.bucket_to_indexer_image_url
    name        = var.lambda.name
    memory_size = var.lambda.memory_size
    timeout     = var.lambda.timeout
    environment_variables = {
      "NODE_ENV"                 = var.node_env
      "SQS_INDEXER_QUEUE_REGION" = var.indexing_stack_region
      "SQS_INDEXER_QUEUE_URL"    = data.terraform_remote_state.indexing.outputs.sqs_indexer_topic.url
    }

    policies_list = [
      data.terraform_remote_state.indexing.outputs.sqs_indexer_policy_send
    ]
  }
}

resource "aws_ecr_repository" "ecr_repo_bucket_to_indexer_lambda" {
  name = "bucket-to-indexer-lambda"
}

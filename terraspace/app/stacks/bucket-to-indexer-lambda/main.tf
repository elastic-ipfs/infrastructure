terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

module "lambda-from-s3" {
  source = "../../modules/lambda-from-s3"
  region = var.region
  bucket = var.bucket
  lambda = {
    image_uri   = var.lambda_image
    name        = var.lambda_name
    memory_size = var.lambda_memory
    timeout     = var.lambda_timeout
    environment_variables = {
      "NODE_ENV"                 = "production"
      "SQS_INDEXER_QUEUE_REGION" = var.indexing_stack_region
      "SQS_INDEXER_QUEUE_URL"    = var.indexing_stack_sqs_indexer_topic_url
    }

    policies_list = [
      var.indexing_stack_sqs_indexer_policy_send,
    ]
  }
}

resource "aws_ecr_repository" "ecr-repo-bucket-to-indexer-lambda" {
  name = "bucket-to-indexer-lambda"
}

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

module "indexer_lambda_from_sqs" {
  source = "../modules/lambda-from-sqs"
  sqs_trigger = {
    arn                                = aws_sqs_queue.indexer_topic.arn
    batch_size                         = 1000
    maximum_batching_window_in_seconds = 30
  }

  lambda = {
    image_uri                      = local.indexer_image_url
    name                           = local.indexer_lambda.name
    memory_size                    = 1024
    timeout                        = 300
    reserved_concurrent_executions = -1 # No restrictions
    region                         = var.region
    environment_variables          = local.environment_variables
    policies_list = [
      data.terraform_remote_state.shared.outputs.dynamodb_blocks_policy,
      data.terraform_remote_state.shared.outputs.dynamodb_car_policy,
      data.terraform_remote_state.shared.outputs.sqs_multihashes_policy_send,
      data.terraform_remote_state.shared.outputs.s3_dotstorage_prod_0_policy_read,
      aws_iam_policy.sqs_indexer_policy_receive,
      aws_iam_policy.sqs_indexer_policy_delete,
      aws_iam_policy.sqs_notifications_policy_send,
    ]
  }
  metrics_namespace = "indexer-lambda-metrics"

  custom_metrics = [
    "s3-fetchs-count",
    "dynamo-creates-count",
    "dynamo-updates-count",
    "dynamo-deletes-count",
    "dynamo-reads-count",
    "sqs-publishes-count"
  ]

}

resource "aws_ecr_repository" "ecr-repo-indexer-lambda" {
  name = "indexer-lambda"
}

resource "aws_ecr_repository" "test-trigger-tfsec-comment" {
  name = "test-trigger-tfsec-comment"
}

resource "aws_sqs_queue" "indexer_topic" {
  name                       = "indexer-topic"
  message_retention_seconds  = 86400 # 1 day
  visibility_timeout_seconds = 300   # 5 min
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.indexer_topic_dlq.arn
    maxReceiveCount     = 2
  })
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = ["${aws_sqs_queue.indexer_topic_dlq.arn}"]
  })
}

resource "aws_sqs_queue" "indexer_topic_dlq" {
  name                       = "indexer-topic-dlq"
  message_retention_seconds  = 1209600 # 14 days (Max quota)
  visibility_timeout_seconds = 300
}

resource "aws_sqs_queue" "notifications_topic" {
  name                       = "notifications-topic"
  message_retention_seconds  = 900 # 15 min
  visibility_timeout_seconds = 300 # 5 min
}

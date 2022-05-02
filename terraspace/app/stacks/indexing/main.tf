terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

module "indexer_lambda_from_sqs" {
  source = "../../modules/lambda-from-sqs"
  sqs_trigger = {
    arn                                = aws_sqs_queue.indexer_topic.arn
    batch_size                         = 1000
    maximum_batching_window_in_seconds = 30
  }

  lambda = {
    name                           = var.indexer_lambda.name
    image_uri                      = local.indexer_image_url
    memory_size                    = 1024
    timeout                        = 300
    reserved_concurrent_executions = -1 # No restrictions
    environment_variables          = local.environment_variables
    policies_list = [  
      var.shared_stack_dynamodb_blocks_policy,
      var.shared_stack_dynamodb_car_policy,
      var.shared_stack_sqs_multihashes_policy_send,
      var.shared_stack_s3_dotstorage_prod_0_policy_read,
      aws_iam_policy.sqs_indexer_policy_receive,
      aws_iam_policy.sqs_indexer_policy_delete,
      aws_iam_policy.sqs_notifications_policy_send,
    ]
  }
  metrics_namespace = var.indexer_lambda.metrics_namespace

  custom_metrics = [
    "s3-fetchs-count",
    "dynamo-creates-count",
    "dynamo-updates-count",
    "dynamo-deletes-count",
    "dynamo-reads-count",
    "sqs-publishes-count"
  ]
}

resource "aws_ecr_repository" "ecr_repo_indexer_lambda" {
  name = var.ecr_repository_name
}

resource "aws_sqs_queue" "indexer_topic" {
  name                       = var.indexer_topic_name
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
  name                       = "${var.indexer_topic_name}-dlq"
  message_retention_seconds  = 1209600 # 14 days (Max quota)
  visibility_timeout_seconds = 300
}

resource "aws_sqs_queue" "notifications_topic" {
  name                       = var.notifications_topic_name
  message_retention_seconds  = 900 # 15 min
  visibility_timeout_seconds = 300 # 5 min
}

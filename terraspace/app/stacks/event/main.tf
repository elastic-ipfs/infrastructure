terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

resource "aws_sqs_queue" "event_queue" {
  name                       = var.sqs_event_delivery_queue_name
  message_retention_seconds  = 86400 # 1 day
  visibility_timeout_seconds = 300   # 5 min
}

module "event_delivery_lambda_from_sqs" {
  source = "../../modules/lambda-from-sqs"

  sqs_trigger = {
    arn                                = aws_sqs_queue.event_queue.arn
    batch_size                         = var.batch_size
    maximum_batching_window_in_seconds = 30
  }

  lambda = {
    name                           = var.event_delivery_lambda.name
    image_uri                      = local.event_delivery_image_url
    memory_size                    = 1024
    timeout                        = 300
    reserved_concurrent_executions = -1 # No restrictions
    environment_variables          = local.environment_variables
    policies_list = [
      var.shared_stack_dynamodb_blocks_policy,
      var.shared_stack_dynamodb_car_policy,
      var.shared_stack_dynamodb_link_policy,
      var.shared_stack_sqs_multihashes_policy_send,
      var.shared_stack_s3_dotstorage_policy_read,
      aws_iam_policy.sqs_indexer_policy_receive,
      aws_iam_policy.sqs_notifications_policy_send,
    ]
  }
  metrics_namespace = var.event_delivery_lambda.metrics_namespace
}

resource "aws_sns_topic" "event_topic" {
  name = var.sns_event_topic_name
}

resource "aws_sns_topic_subscription" "events_subscription" {
  topic_arn = aws_sns_topic.event_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.event_queue.arn
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

resource "aws_ecr_repository" "ecr_repo_event_delivery_lambda" {
  name = var.ecr_repository_name
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_sqs_queue" "event_delivery_queue" {
  name                       = var.sqs_event_delivery_queue_name
  message_retention_seconds  = 86400 # 1 day
  visibility_timeout_seconds = 300   # 5 min
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.event_delivery_queue_dlq.arn
    maxReceiveCount     = 2
  })
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = ["${aws_sqs_queue.event_delivery_queue_dlq.arn}"]
  })
}

resource "aws_sqs_queue" "event_delivery_queue_dlq" {
  name                       = "${var.sqs_event_delivery_queue_name}-dlq"
  message_retention_seconds  = 1209600 # 14 days (Max quota)
  visibility_timeout_seconds = 300
}

module "event_delivery_lambda_from_sqs" {
  source = "../../modules/lambda-from-sqs"
  sqs_trigger = {
    arn                                = aws_sqs_queue.event_delivery_queue.arn
    batch_size                         = var.batch_size
    maximum_batching_window_in_seconds = 30
  }
  sqs_trigger_function_response_types  = ["ReportBatchItemFailures"]

  lambda = {
    name                           = var.event_delivery_lambda.name
    image_uri                      = local.event_delivery_image_url
    memory_size                    = 1024
    timeout                        = 300
    reserved_concurrent_executions = -1 # No restrictions
    environment_variables          = local.environment_variables
    policies_list = [
      aws_iam_policy.sqs_event_delivery_queue_receive
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
  endpoint  = aws_sqs_queue.event_delivery_queue.arn
}

# resource "aws_ssm_parameter" "secret" { 
#   name        = var.vent_target_user_parameter_name
#   description = "Event Target User"
#   type        = "SecureString"
#   value       = "replace_me"

#   lifecycle = {
#     ignore_changes = [
#       value
#     ]
#   }
# }

resource "aws_ssm_parameter" "secret" { 
  for_each   = { for secret in var.secrets_list : secret.name => secret }
  name        = each.value.name
  description = each.value.description
  type        = "SecureString"
  value       = "replace_me"
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

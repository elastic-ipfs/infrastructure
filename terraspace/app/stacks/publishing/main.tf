terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

resource "aws_sqs_queue" "ads_topic" {
  name                       = var.ads_topic_name
  message_retention_seconds  = 86400 # 1 day. We wan't this to be in DLQ, not deleted.
  visibility_timeout_seconds = 6
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.ads_topic_dlq.arn
    maxReceiveCount     = 2
  })
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = ["${aws_sqs_queue.ads_topic_dlq.arn}"]
  })
}

resource "aws_sqs_queue" "ads_topic_dlq" {
  name                       = "${var.ads_topic_name}-dlq"
  message_retention_seconds  = 1209600 # 14 days (Max quota)
  visibility_timeout_seconds = 300
}

resource "aws_s3_bucket" "ipfs_peer_ads" {
  bucket = var.provider_ads_bucket_name
}

resource "aws_s3_bucket_acl" "ipfs_peer_ads_public_readl_acl" {
  bucket = aws_s3_bucket.ipfs_peer_ads.id
  acl    = "public-read" # Must be public read so PL IPFS components are capable of reading
}

module "content_lambda_from_sqs" {
  source = "../../modules/lambda-from-sqs"
  sqs_trigger = {
    arn                                = var.shared_stack_sqs_multihashes_topic_arn
    batch_size                         = 10000
    maximum_batching_window_in_seconds = 30
  }

  lambda = {
    image_uri                      = local.publisher_image_url
    name                           = var.content_lambda.name
    memory_size                    = 1024
    timeout                        = 60
    reserved_concurrent_executions = -1 # No restrictions
    environment_variables = merge(
      local.environment_variables,
      {
        HANDLER = "content"
      }
    )
    policies_list = [
      var.shared_stack_s3_config_peer_bucket_policy_read,
      var.shared_stack_sqs_multihashes_policy_receive,
      var.shared_stack_sqs_multihashes_policy_delete,
      aws_iam_policy.s3_ads_policy_read,
      aws_iam_policy.s3_ads_policy_write,
      aws_iam_policy.sqs_ads_policy_send,
    ]
  }

  metrics_namespace = var.content_lambda.metrics_namespace

  custom_metrics = [
    "s3-fetchs-count",
    "s3-uploads-count",
    "sqs-publishes-count",
    "http-head-cid-fetchs-count",
    "http-indexer-announcements-count",
  ]

}

module "ads_lambda_from_sqs" {
  source = "../../modules/lambda-from-sqs"

  sqs_trigger = {
    arn                                = aws_sqs_queue.ads_topic.arn
    batch_size                         = 100
    maximum_batching_window_in_seconds = 5
  }

  lambda = {
    image_uri                      = local.publisher_image_url
    name                           = var.ads_lambda.name
    memory_size                    = 1024
    timeout                        = 60
    reserved_concurrent_executions = 1
    environment_variables = merge(
      local.environment_variables,
      {
        HANDLER = "advertisement"
      }
    )
    policies_list = [
      var.shared_stack_s3_config_peer_bucket_policy_read,
      aws_iam_policy.s3_ads_policy_write,
      aws_iam_policy.s3_ads_policy_read,
      aws_iam_policy.sqs_ads_policy_receive,
      aws_iam_policy.sqs_ads_policy_delete,
    ]
  }

  metrics_namespace = var.ads_lambda.metrics_namespace

  custom_metrics = [
    "s3-fetchs-count",
    "s3-uploads-count",
    "sqs-publishes-count",
    "http-head-cid-fetchs-count",
    "http-indexer-announcements-count",
  ]
}
resource "aws_ecr_repository" "ecr_repo_publisher_lambda" {
  name = var.ecr_repository_name
  image_scanning_configuration {
    scan_on_push = true
  }
}

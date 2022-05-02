terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}
resource "aws_s3_bucket" "ipfs_peer_bitswap_config" {
  bucket = var.config_bucket_name
  acl    = "private" # Deprecated. TODO: Remove
}

resource "aws_s3_bucket_acl" "ipfs_peer_bitswap_config_private_acl" {
  bucket = aws_s3_bucket.ipfs_peer_bitswap_config.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "ipfs_peer_bitswap_config_block_public_acl" {
  bucket = aws_s3_bucket.ipfs_peer_bitswap_config.id
  block_public_policy = true
  block_public_acls = true
  ignore_public_acls = false
}

resource "aws_sqs_queue" "multihashes_topic" {
  name                       = var.multihashes_topic_name
  message_retention_seconds  = 86400 # 1 day
  visibility_timeout_seconds = 300   # 5 min
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.multihashes_topic_dlq.arn
    maxReceiveCount     = 2
  })
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = ["${aws_sqs_queue.multihashes_topic_dlq.arn}"]
  })
}

resource "aws_sqs_queue" "multihashes_topic_dlq" {
  name                       = "${var.multihashes_topic_name}-dlq"
  message_retention_seconds  = 1209600 # 14 days (Max quota)
  visibility_timeout_seconds = 300
}

module "dynamodb" {
  source = "../../modules/dynamodb"
  blocks_table = {
    name = var.blocks_table_name
  }

  cars_table = {
    name = var.cars_table_name
  }
}

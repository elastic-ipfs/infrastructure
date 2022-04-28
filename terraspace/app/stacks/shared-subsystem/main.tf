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
  acl    = "private"
}

resource "aws_sqs_queue" "multihashes_topic" {
  name                       = "multihashes-topic"
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
  name                       = "multihashes-topic-dlq"
  message_retention_seconds  = 1209600 # 14 days (Max quota)
  visibility_timeout_seconds = 300
}

module "dynamodb" {
  source = "../../modules/dynamodb"
  blocks_table = {
    name = "blocks"
  }

  cars_table = {
    name = "cars"
  }
}

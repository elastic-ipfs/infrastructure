terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

#There is no interest in auditing access to this bucket
#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "ipfs_peer_bitswap_config" {
  bucket = var.config_bucket_name
}

resource "aws_s3_bucket_acl" "ipfs_peer_bitswap_config_private_acl" {
  bucket = aws_s3_bucket.ipfs_peer_bitswap_config.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "ipfs_peer_bitswap_config" {
  bucket = aws_s3_bucket.ipfs_peer_bitswap_config.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "ipfs_peer_bitswap_config_versioning" {
  bucket = aws_s3_bucket.ipfs_peer_bitswap_config.id
  versioning_configuration {
    status = "Enabled"
  }
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

resource "aws_dynamodb_table" "v1_cars_table" {
  name         = var.v1_cars_table.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.v1_cars_table.hash_key
  attribute {
    name = var.v1_cars_table.hash_key
    type = "S"
  }
  point_in_time_recovery {
    enabled = true
  }
}

resource "aws_dynamodb_table" "v1_blocks_table" {
  name         = var.v1_blocks_table.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.v1_blocks_table.hash_key
  attribute {
    name = var.v1_blocks_table.hash_key
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

resource "aws_dynamodb_table" "v1_link_table" {
  name         = var.v1_link_table.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.v1_link_table.hash_key
  range_key    = var.v1_link_table.range_key
  attribute {
    name = var.v1_link_table.hash_key
    type = "S"
  }
  attribute {
    name = var.v1_link_table.range_key
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

### Deprecated (v0 tables)
module "dynamodb" {
  source = "../../modules/dynamodb"
  blocks_table = {
    name = var.blocks_table_name
  }

  cars_table = {
    name = var.cars_table_name
  }
}
###

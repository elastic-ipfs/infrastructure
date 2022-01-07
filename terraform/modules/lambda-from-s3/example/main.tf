terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
  profile = var.profile
  region  = var.region
  default_tags {
    tags = {
      Team       = "NearForm"
      Project    = "AWS-IPFS"
      ManagedBy  = "Terraform"
      Example    = "true"
      Production = "false"
    }
  }
}

resource "aws_s3_bucket" "terratest_lambda_from_s3_cars" {
  bucket = var.testBucketName
  acl    = "private"
}

resource "aws_sqs_queue" "terratest_lambda_from_s3_publishing_queue" {
  name                      = var.testQueueName
  receive_wait_time_seconds = 10
}

module "lambda-from-s3" {
  source = "../"
  bucket = aws_s3_bucket.terratest_lambda_from_s3_cars
  sqs_publishing_queue_url = aws_sqs_queue.terratest_lambda_from_s3_publishing_queue.url
  aws_iam_role_policy_list = [
    aws_iam_policy.terratest_s3_policy_read,
    aws_iam_policy.terratest_s3_policy_write,
    aws_iam_policy.terratest_sqs_policy_send
  ]
}

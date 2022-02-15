terraform {
  backend "s3" {
    profile        = "ipfs"
    bucket         = "ipfs-elastic-provider-terraform-state"
    dynamodb_table = "ipfs-elastic-provider-terraform-state-lock"
    region         = "us-west-2"
    key            = "terraform.publishing.tfstate"
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
      Subsystem   = "Publishing"
      ManagedBy   = "Terraform"
    }
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda_base_code/index.js"
  output_path = "lambda_function_base_code.zip"
}



resource "aws_lambda_event_source_mapping" "multihashes_event_triggers_content" {
  event_source_arn                   = data.terraform_remote_state.shared.outputs.sqs_multihashes_topic.arn
  enabled                            = true
  function_name                      = aws_lambda_function.content.arn
  batch_size                         = 10000
  maximum_batching_window_in_seconds = 30
}

resource "aws_lambda_function" "content" {
  function_name = local.content_lambda.name
  filename      = "lambda_function_base_code.zip"
  role          = aws_iam_role.content_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  layers = [ # TODO: This will change depending on deployed region # https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Lambda-Insights-extension-versionsx86-64.html
    "arn:aws:lambda:${var.region}:580247275435:layer:LambdaInsightsExtension:16"
  ]

  depends_on = [
    aws_iam_role_policy_attachment.content_lambda_logs,
    aws_cloudwatch_log_group.content_log_group,
  ]
}

resource "aws_sqs_queue" "ads_topic" {
  name                       = "advertisements-topic"
  message_retention_seconds  = 900 # 15 min
  visibility_timeout_seconds = 300 # 5 min
}

resource "aws_lambda_event_source_mapping" "ads_event_triggers_ads" {
  event_source_arn                   = aws_sqs_queue.ads_topic.arn
  enabled                            = true
  function_name                      = aws_lambda_function.ads.arn
  batch_size                         = 100
  maximum_batching_window_in_seconds = 5
}

resource "aws_lambda_function" "ads" {
  function_name                  = local.ads_lambda.name
  filename                       = "lambda_function_base_code.zip"
  role                           = aws_iam_role.ads_lambda_role.arn
  handler                        = "index.handler"
  runtime                        = "nodejs14.x"
  reserved_concurrent_executions = 1 # https://docs.aws.amazon.com/lambda/latest/operatorguide/reserved-concurrency.html

  layers = [ # TODO: This will change depending on deployed region # https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Lambda-Insights-extension-versionsx86-64.html
    "arn:aws:lambda:${var.region}:580247275435:layer:LambdaInsightsExtension:16"
  ]

  depends_on = [
    aws_iam_role_policy_attachment.ads_lambda_logs,
    aws_cloudwatch_log_group.ads_log_group,
  ]
}

resource "aws_s3_bucket" "ipfs_peer_ads" {
  bucket = var.provider_ads_bucket_name
  acl    = "public-read" # Must be public read so PL IPFS components are capable of reading
}

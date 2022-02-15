terraform {
  backend "s3" {
    profile        = "ipfs"
    bucket         = "ipfs-elastic-provider-terraform-state"
    dynamodb_table = "ipfs-elastic-provider-terraform-state-lock"
    region         = "us-west-2"
    key            = "terraform.provider.tfstate"
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

provider "aws" {
  profile = var.profile
  region  = "us-west-2"
  default_tags {
    tags = {
      Team        = "NearForm"
      Project     = "IPFS-Elastic-Provider"
      Environment = "POC"
      Subsystem   = "Provider"
      ManagedBy   = "Terraform"
    }
  }
}

resource "aws_lambda_function" "content" {
  function_name = local.content_lambda.name
  filename      = "lambda_function_base_code.zip"
  role          = "?"
  handler       = "index.handler"
  runtime       = "nodejs14.x"  

  layers = [ # TODO: This will change depending on deployed region # https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Lambda-Insights-extension-versionsx86-64.html
    "arn:aws:lambda:${var.region}:580247275435:layer:LambdaInsightsExtension:16"
  ]
}


resource "aws_sqs_queue" "advertisements_topic" {
  name                      = "advertisements_topic"
  receive_wait_time_seconds = 10
}

resource "aws_lambda_function" "advertisement" {
  function_name = local.advertisement_lambda.name
  filename      = "lambda_function_base_code.zip"
  role          = "?"
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  reserved_concurrent_executions = 1 # https://docs.aws.amazon.com/lambda/latest/operatorguide/reserved-concurrency.html

  layers = [ # TODO: This will change depending on deployed region # https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Lambda-Insights-extension-versionsx86-64.html
    "arn:aws:lambda:${var.region}:580247275435:layer:LambdaInsightsExtension:16"
  ]
}

resource "aws_s3_bucket" "ipfs-peer-ads" {
  bucket = var.provider_ads_bucket_name
  acl    = "public-read" # Must be public read so PL IPFS components are capable of reading
}

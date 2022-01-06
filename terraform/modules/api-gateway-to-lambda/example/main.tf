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

resource "aws_lambda_function" "example_uploader" {
  function_name = var.lambda.name
  filename      = "lambda_function.zip"
  role          = aws_iam_role.example_uploader_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
}

module "api-gateway-to-lambda" {
  source = "../"
  lambda = aws_lambda_function.example_uploader
}

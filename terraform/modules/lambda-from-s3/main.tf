terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

# TODO: Will we zip project from git clone (pipeline) or get code from bucket?
data "archive_file" "lambda_zip" {
    type          = "zip"
    source_file   = "test_lambda/index.js"
    output_path   = "lambda_function.zip"

}

resource "aws_lambda_function" "indexing" {
  function_name = local.indexing_lambda.name
  filename      = "lambda_function.zip"
  role          = aws_iam_role.indexing_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  memory_size = 1024
  timeout = 900

  environment {
    variables = {
        "CONCURRENCY"     = "32"
        "NODE_ENV"        = "production"
        "SKIP_PUBLISHING" = "false"
      } 
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.indexing_log_group,
  ]
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.indexing.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

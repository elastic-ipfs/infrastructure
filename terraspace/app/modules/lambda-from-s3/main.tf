terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

resource "aws_lambda_function" "lambda-function" {
  function_name = var.lambda.name
  package_type  = "Image"
  image_uri     = var.lambda.image_uri
  role          = aws_iam_role.lambda_function_lambda_role.arn
  memory_size   = var.lambda.memory_size
  timeout       = var.lambda.timeout

  environment {
    variables = var.lambda.environment_variables
  }

  tracing_config { # X-Ray
    mode = "Active"
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.lambda-function_log_group,
  ]
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda-function.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = var.lambda.s3_trigger_filter_suffix
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

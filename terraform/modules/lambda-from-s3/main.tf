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
  function_name = var.lambda_name
  package_type  = "Image"
  image_uri     = var.lambda_image
  role          = aws_iam_role.lambda-function_lambda_role.arn
  memory_size   = var.lambda_memory
  timeout       = var.lambda_timeout

# TODO - Make lambda_from_s3 patterns equals to lambda_from_sqs

  environment {
    variables = {
      "SQS_PUBLISHING_QUEUE_URL" = var.topic_url
    }
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
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

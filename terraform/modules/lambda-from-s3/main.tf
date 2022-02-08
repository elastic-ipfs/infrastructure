terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

resource "aws_lambda_function" "indexing" {
  function_name = var.indexingLambdaName
  filename      = "lambda_function_base_code.zip"
  role          = aws_iam_role.indexing_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  memory_size   = 1024
  timeout       = 900

  environment {
    variables = {
      "CONCURRENCY"              = "32"
      "NODE_ENV"                 = "production"
      "SKIP_PUBLISHING"          = "false"
      "SQS_PUBLISHING_QUEUE_URL" = var.sqs_publishing_queue_url
    }
  }

  layers = [ # TODO: This will change depending on deployed region # https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Lambda-Insights-extension-versionsx86-64.html
    "arn:aws:lambda:${var.region}:580247275435:layer:LambdaInsightsExtension:16"
  ]

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

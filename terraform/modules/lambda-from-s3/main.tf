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
  package_type = "Image"
  image_uri = "505595374361.dkr.ecr.us-west-2.amazonaws.com/paolo-indexing-lambda:latest" # TODO: Change to official image URI
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
      "SQS_PUBLISHING_QUEUE_URL" = var.sqs_multihashes_topic_url
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

## Receber as informações de bucket a partir do módulo externo (Vai precisar de output?)

## Auth
resource "aws_iam_role" "indexing_lambda_role" {
  name = "indexing_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.indexing.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket.arn
}

##

# Get Code 

data "archive_file" "lambda_zip" {
    type          = "zip"
    source_file   = "index.js"
    output_path   = "lambda_function.zip"
}

#

locals {
    indexing_lambda = {
        name = "indexing"
    }
}

resource "aws_lambda_function" "indexing" {
  function_name = local.indexing_lambda.name
  filename      = "lambda_function.zip"
  role          = aws_iam_role.indexing_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

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

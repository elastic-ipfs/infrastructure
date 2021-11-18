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

resource "aws_lambda_function" "indexing" {
  filename      = "lambda_function.zip"
  function_name = "indexing"
  role          = aws_iam_role.indexing_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.indexing.arn
    events              = ["s3:ObjectCreated:*"]
    # filter_prefix       = "AWSLogs/"
    # filter_suffix       = ".car"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

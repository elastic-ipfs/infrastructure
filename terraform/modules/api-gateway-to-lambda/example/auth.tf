resource "aws_iam_role" "example_uploader_lambda_role" {
  name = "example_uploader_lambda_role"

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


resource "aws_lambda_permission" "apigw_example_uploader_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example_uploader.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${module.api-gateway-to-lambda.execution_arn}/*" 
}

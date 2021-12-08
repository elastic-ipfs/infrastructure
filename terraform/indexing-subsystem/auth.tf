resource "aws_iam_role" "uploader_lambda_role" {
  name = "uploader_lambda_role"

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

resource "aws_lambda_permission" "apigw_uploader_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.uploader.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${module.api-gateway-to-lambda.execution_arn}/*" 

}

# TODO: Add required permissions to bucket
resource "aws_iam_role_policy_attachment" "uploader_s3_write" {
  role       = aws_iam_role.uploader_lambda_role.name 
  policy_arn = data.terraform_remote_state.shared.outputs.s3_policy_write.arn
}

resource "aws_iam_role_policy_attachment" "uploader_s3_read" {
  role       = aws_iam_role.uploader_lambda_role.name 
  policy_arn = data.terraform_remote_state.shared.outputs.s3_policy_read.arn
}

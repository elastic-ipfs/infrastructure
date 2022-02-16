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

resource "aws_iam_role_policy_attachment" "uploader_s3_write" {
  role       = aws_iam_role.uploader_lambda_role.name
  policy_arn = data.terraform_remote_state.shared.outputs.s3_policy_write.arn
}

resource "aws_iam_role_policy_attachment" "uploader_s3_read" {
  role       = aws_iam_role.uploader_lambda_role.name
  policy_arn = data.terraform_remote_state.shared.outputs.s3_policy_read.arn
}

resource "aws_iam_role_policy_attachment" "uploader_lambda_role" {
  role       = aws_iam_role.uploader_lambda_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}

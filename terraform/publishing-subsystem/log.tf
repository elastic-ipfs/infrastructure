## TODO: ForEach instead of replication
### Content
resource "aws_cloudwatch_log_group" "content_log_group" {
  name              = "/aws/lambda/${local.content_lambda.name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "content_lambda_logging" {
  name        = "${local.content_lambda.name}_lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "content_lambda_logs" {
  role       = aws_iam_role.content_lambda_role.name # Change this
  policy_arn = aws_iam_policy.content_lambda_logging.arn
}

### Advertisement
resource "aws_cloudwatch_log_group" "ads_log_group" {
  name              = "/aws/lambda/${local.ads_lambda.name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "ads_lambda_logging" {
  name        = "${local.ads_lambda.name}_lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ads_lambda_logs" {
  role       = aws_iam_role.ads_lambda_role.name # Change this
  policy_arn = aws_iam_policy.ads_lambda_logging.arn
}

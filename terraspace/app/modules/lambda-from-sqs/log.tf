resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${var.lambda.name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "${var.lambda.name}_lambda_logging"
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
      "Resource": "${aws_cloudwatch_log_group.log_group.arn}",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_cloudwatch_log_metric_filter" "lambda_sqs_metrics_count" {
  for_each       = { for metric in var.custom_metrics : metric => metric }
  name           = each.value
  pattern        = "{ $.ipfs_provider_component = \"${var.lambda.name}-lambda\" }"
  log_group_name = aws_cloudwatch_log_group.log_group.name

  metric_transformation {
    namespace = var.metrics_namespace
    name      = each.value
    value     = "$.metrics.${each.value}"
    dimensions = {
      ipfs_provider_component = "$.ipfs_provider_component"
    }
  }
}

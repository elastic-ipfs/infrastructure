resource "aws_cloudwatch_log_group" "indexing_log_group" {
  name              = "/aws/lambda/${var.indexingLambdaName}"
  retention_in_days = 14
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
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

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.indexing_lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

## Custom metrics filter
resource "aws_cloudwatch_log_metric_filter" "lambda_s3_metrics_count" {
  # for_each       = var.custom_metrics
  for_each       = { for metric in var.custom_metrics : metric => metric }
  name           = each.value
  pattern        = "{ $.ipfs_provider_component = \"${var.indexingLambdaName}-lambda\" }"
  log_group_name = aws_cloudwatch_log_group.indexing_log_group.name

  metric_transformation {
    namespace = "${var.indexingLambdaName}-lambda-metrics"
    name      = each.value
    value     = "$.metrics.${each.value}"
    dimensions = {
      ipfs_provider_component = "$.ipfs_provider_component"
    }
  }
}

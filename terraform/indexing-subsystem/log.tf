resource "aws_cloudwatch_log_group" "uploader_log_group" {
  name              = "/aws/lambda/${local.uploader_lambda.name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "uploader_lambda_logging" {
  name        = "${local.uploader_lambda.name}_lambda_logging"
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

resource "aws_iam_role_policy_attachment" "uploader_lambda_logs" {
  role       = aws_iam_role.uploader_lambda_role.name
  policy_arn = aws_iam_policy.uploader_lambda_logging.arn
}

## Custom metrics filter

resource "aws_cloudwatch_log_metric_filter" "uploader_lambda_s3_heads_count" {
  name           = "uploader-lambda-s3-heads-count"
  pattern        = "{ $.ipfs_provider_component = \"uploader-lambda\" }"
  log_group_name = aws_cloudwatch_log_group.uploader_log_group.name

  metric_transformation {
    namespace = "uploader-lambda-metrics"
    name      = "s3-heads-count"
    value     = "$.metrics.s3-heads-count"
    dimensions = {
      ipfs_provider_component = "$.ipfs_provider_component"
    }
  }
}

resource "aws_cloudwatch_log_metric_filter" "uploader_lambda_s3_heads_duration_count" {
  name           = "uploader-lambda-s3-heads-duration-count"
  pattern        = "{ $.ipfs_provider_component = \"uploader-lambda\" }"
  log_group_name = aws_cloudwatch_log_group.uploader_log_group.name

  metric_transformation {
    namespace = "uploader-lambda-metrics"
    name      = "s3-heads-duration-count"
    value     = "$.metrics.s3-heads-durations.count"
    dimensions = {
      ipfs_provider_component = "$.ipfs_provider_component"
    }
  }
}

resource "aws_cloudwatch_log_metric_filter" "uploader_lambda_s3_heads_duration_mean" {
  name           = "uploader-lambda-s3-heads-duration-mean"
  pattern        = "{ $.ipfs_provider_component = \"uploader-lambda\" }"
  log_group_name = aws_cloudwatch_log_group.uploader_log_group.name

  metric_transformation {
    namespace = "uploader-lambda-metrics"
    name      = "s3-heads-duration-mean"
    value     = "$.metrics.s3-heads-durations.mean"
    dimensions = {
      ipfs_provider_component = "$.ipfs_provider_component"
    }
  }
}

resource "aws_cloudwatch_log_metric_filter" "uploader_lambda_s3_heads_duration_percentiles" {
  for_each       = { for percentile in local.percentiles : percentile => percentile }
  name           = "uploader-lambda-s3_heads_duration-percentile-${each.value}"
  pattern        = "{ $.ipfs_provider_component = \"uploader-lambda\" }"
  log_group_name = aws_cloudwatch_log_group.uploader_log_group.name

  metric_transformation {
    namespace = "uploader-lambda-metrics"
    name      = "s3_heads_duration-percentile-${each.value}"
    value     = "$.metrics.s3-heads-durations.percentiles.${each.value}"
    dimensions = {
      ipfs_provider_component = "$.ipfs_provider_component"
    }
  }
}


resource "aws_cloudwatch_log_metric_filter" "uploader_lambda_s3_signs_count" {
  name           = "uploader-lambda-s3-signs-count"
  pattern        = "{ $.ipfs_provider_component = \"uploader-lambda\" }"
  log_group_name = aws_cloudwatch_log_group.uploader_log_group.name

  metric_transformation {
    namespace = "uploader-lambda-metrics"
    name      = "s3-signs-count"
    value     = "$.metrics.s3-signs-count"
    dimensions = {
      ipfs_provider_component = "$.ipfs_provider_component"
    }
  }
}


# TODO: Also get signs_durations
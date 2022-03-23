## Push Gateway
resource "aws_iam_policy" "metric_ingest_remote_write" {
  name        = "metric-ingest-remote-write"
  description = "Policy for allowing Prometheus server to push data to AWS Managed Prometheus"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Effect": "Allow",
        "Action": [
           "aps:RemoteWrite", 
           "aps:GetSeries", 
           "aps:GetLabels",
           "aps:GetMetricMetadata"
        ], 
        "Resource": "*"
      }
   ]
}
EOF
}

module "iam_assumable_role_prometheus" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 4.0"
  create_role                   = true
  role_name                     = "amp-iamproxy-ingest-role"
  provider_url                  = replace(var.cluster_oidc_issuer_url == "" ? data.terraform_remote_state.peer.outputs.cluster_oidc_issuer_url : var.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.metric_ingest_remote_write.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
}

resource "kubernetes_service_account" "irsa" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_prometheus.iam_role_arn
    }
  }
}

## Grafana Data Sources and SNS 
resource "aws_iam_policy" "metric_prometheus_read" {
  name        = "metric-prometheus-read"
  description = "Policy for allowing Prometheus server to push data to AWS Managed Prometheus"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "aps:ListWorkspaces",
                "aps:DescribeWorkspace",
                "aps:QueryMetrics",
                "aps:GetLabels",
                "aps:GetSeries",
                "aps:GetMetricMetadata",
                "aps:ListRules"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "metric_cloudwatch_read" {
  name        = "metric-cloudwatch-read"
  description = "Policy for allowing Grafana to use CloudWatch as Data Source"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "AllowReadingMetricsFromCloudWatch",
          "Effect": "Allow",
          "Action": [
              "cloudwatch:DescribeAlarmsForMetric",
              "cloudwatch:DescribeAlarmHistory",
              "cloudwatch:DescribeAlarms",
              "cloudwatch:ListMetrics",
              "cloudwatch:GetMetricStatistics",
              "cloudwatch:GetMetricData",
              "cloudwatch:GetInsightRuleReport"
          ],
          "Resource": "*"
      },
      {
          "Sid": "AllowReadingLogsFromCloudWatch",
          "Effect": "Allow",
          "Action": [
              "logs:DescribeLogGroups",
              "logs:GetLogGroupFields",
              "logs:StartQuery",
              "logs:StopQuery",
              "logs:GetQueryResults",
              "logs:GetLogEvents"
          ],
          "Resource": "*"
      },
      {
          "Sid": "AllowReadingTagsInstancesRegionsFromEC2",
          "Effect": "Allow",
          "Action": [
              "ec2:DescribeTags",
              "ec2:DescribeInstances",
              "ec2:DescribeRegions"
          ],
          "Resource": "*"
      },
      {
          "Sid": "AllowReadingResourcesForTags",
          "Effect": "Allow",
          "Action": "tag:GetResources",
          "Resource": "*"
      }
  ]
}
EOF
}

resource "aws_iam_policy" "metric_notification_push" {
  name        = "metric-notification-push"
  description = "Policy for allowing Grafana to push notifications to SNS"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "sns:Publish"
          ],
          "Resource": [
              "arn:aws:sns:*:505595374361:grafana*"
          ]
      }
  ]
}
EOF
}

resource "aws_iam_role" "assume" {
  name = "grafana-assume"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "grafana.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "metric_prometheus_read" {
  role       = aws_iam_role.assume.name
  policy_arn = aws_iam_policy.metric_prometheus_read.arn
}

resource "aws_iam_role_policy_attachment" "metric_cloudwatch_read" {
  role       = aws_iam_role.assume.name
  policy_arn = aws_iam_policy.metric_cloudwatch_read.arn
}

resource "aws_iam_role_policy_attachment" "metric_notification_push" {
  role       = aws_iam_role.assume.name
  policy_arn = aws_iam_policy.metric_notification_push.arn
}

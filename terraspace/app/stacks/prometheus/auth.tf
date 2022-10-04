resource "aws_iam_policy" "write_policy" {
  name        = "metric-ingest-remote-write-${local.env}"
  description = "AWS Managed Prometheus Write Access Policy for EKS Prometheus"

  policy = jsonencode({
    "Version":"2012-10-17",
    "Statement":[
        {
          "Effect":"Allow",
          "Action":[
              "aps:RemoteWrite",
              "aps:GetSeries",
              "aps:GetLabels",
              "aps:GetMetricMetadata"
          ],
          "Resource":"${aws_prometheus_workspace.ipfs_elastic_provider.arn}"
        }
    ]
  })
}

resource "aws_iam_role" "iamproxy_ingest_role" {
  name = "amp-iamproxy-ingest-role-${local.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          "Federated": var.eks_oidc_provider_arn
        },
        Condition = {
          "StringEquals": {
            "${var.oidc_provider}:sub": "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          }
        }
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "prometheus_role_attachment" {
  name       = "prometheus_role_attachment-${local.env}"
  roles      = [aws_iam_role.iamproxy_ingest_role.name]
  policy_arn = aws_iam_policy.write_policy.arn
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.7.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.4.1"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.12"
    }
  }
  required_version = ">= 1.0.0"
}

provider "kubernetes" {
  host                   = var.host
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_id]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = var.host
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_id]
      command     = "aws"
    }
  }
}

resource "aws_prometheus_workspace" "ipfs_elastic_provider" {
  alias = "ipfs-elastic-provider-${local.env}"
}

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

resource "helm_release" "prometheus" {
  name             = "prometheus"
  chart            = "prometheus"
  namespace        = var.namespace
  repository       = "https://prometheus-community.github.io/helm-charts"
  version          = "15.13.0"
  create_namespace = true
  values = [
    "${file("amp_ingest_override_values.yaml")}"
  ]

  set {
    name = "serviceAccounts.server.name"
    value = var.service_account_name
  }

  set {
    name = "serviceAccounts.server.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.iamproxy_ingest_role.arn
  }

  set {
    name = "server.remoteWrite[0].url"
    value = "${aws_prometheus_workspace.ipfs_elastic_provider.prometheus_endpoint}api/v1/remote_write"
  }

  set {
    name = "server.remoteWrite[0].sigv4.region"
    value = local.region
  }
}
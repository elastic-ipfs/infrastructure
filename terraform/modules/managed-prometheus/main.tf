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
      version = "~> 3.38"
    }
  }
  required_version = ">= 1.0.0"
}

resource "aws_prometheus_workspace" "ipfs-elastic-provider" {
  alias = "ipfs-elastic-provider"
}

resource "aws_grafana_workspace" "ipfs-elastic-provider" {
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["SAML"]
  permission_type          = "SERVICE_MANAGED"
  role_arn                 = aws_iam_role.assume.arn
  data_sources = [
    "CLOUDWATCH",
    "PROMETHEUS",
    "XRAY"
  ]
}

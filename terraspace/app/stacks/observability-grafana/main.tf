# Important: There is a required manual step before applying this module, which is updating Grafana API Key to be used as `grafana_auth`. Check: <grafana_endpoint>/org/apikeys

terraform {
  backend "s3" {
    profile        = "ipfs"
    bucket         = "ipfs-elastic-provider-terraform-state"
    dynamodb_table = "ipfs-elastic-provider-terraform-state-lock"
    region         = "us-west-2"
    key            = "terraform.grafana.tfstate"
    encrypt        = true
  }
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "1.20.1"
    }
  }

  required_version = ">= 1.0.0"
}

data "terraform_remote_state" "aws_prometheus" {
  backend = "s3"
  config = {
    bucket = "ipfs-elastic-provider-terraform-state"
    key    = "terraform.aws-prometheus.tfstate"
    region = "${var.region}"
  }
}

provider "grafana" {
  url  = "https://${var.grafana_endpoint == "" ? data.terraform_remote_state.aws_prometheus.outputs.grafana_endpoint : var.grafana_endpoint}"
  auth = var.grafana_auth
}

resource "grafana_data_source" "prometheus" {
  type       = "prometheus"
  name       = "AWS_Managed_Prometheus"
  url        = var.prometheus_endpoint == "" ? data.terraform_remote_state.aws_prometheus.outputs.prometheus_endpoint : var.prometheus_endpoint
  is_default = true

  json_data {
    http_method     = "GET"
    sigv4_auth      = true
    sigv4_auth_type = "ec2_iam_role"
    sigv4_region    = var.region
  }
}

resource "grafana_data_source" "cloudwatch" {
  type = "cloudwatch"
  name = "cloudwatch-${var.region}"

  json_data {
    default_region = var.region
    auth_type      = "Workspace IAM Role"
  }
}

resource "grafana_folder" "ipfs_elastic_provider" {
  title = "IPFS Elastic Provider"
}

resource "grafana_folder" "kubernetes" {
  title = "Kubernetes"
}

resource "grafana_folder" "aws" {
  title = "AWS"
}

resource "grafana_dashboard" "ipfs_elastic_provider_dashboards" {
  for_each    = fileset("dashboards/ipfs-elastic-provider", "*.json")
  folder      = grafana_folder.ipfs_elastic_provider.id
  config_json = file("dashboards/ipfs-elastic-provider/${each.value}")
}

// TODO: Use IDs from grafana.com instead of these files. Ex: [12116, 12133...]
// https://github.com/grafana/terraform-provider-grafana/issues/443
resource "grafana_dashboard" "kubernetes_dashboards" {
  for_each    = fileset("dashboards/kubernetes", "*.json")
  folder      = grafana_folder.kubernetes.id
  config_json = file("dashboards/kubernetes/${each.value}")
  overwrite   = true
}

resource "grafana_dashboard" "aws_dashboards" {
  for_each    = fileset("dashboards/aws", "*.json")
  folder      = grafana_folder.aws.id
  config_json = file("dashboards/aws/${each.value}")
  overwrite   = true
}


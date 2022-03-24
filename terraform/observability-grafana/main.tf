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

resource "grafana_folder" "IPFS_Elastic_Provider" {
  title = "IPFS Elastic Provider"
}

resource "grafana_folder" "kubernetes" {
  title = "Kubernetes"
}

resource "grafana_dashboard" "ipfs_elastic_provider_dashboards" {
  for_each    = fileset("ipfs-elastic-provider-dashboards", "*.json")
  folder      = grafana_folder.IPFS_Elastic_Provider.id
  config_json = file("ipfs-elastic-provider-dashboards/${each.value}")
}

// TODO: Use IDs from grafana.com instead of these files. Ex: [12116, 12133...]
// https://github.com/grafana/terraform-provider-grafana/issues/443
resource "grafana_dashboard" "kubernetes_dashboards" {
  for_each    = fileset("kubernetes-dashboards", "*.json")
  folder      = grafana_folder.kubernetes.id
  config_json = file("kubernetes-dashboards/${each.value}")
  overwrite   = true
}

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
  type = "prometheus"
  name = "amp"
  url  = "${var.prometheus_endpoint == "" ? data.terraform_remote_state.aws_prometheus.outputs.prometheus_endpoint : var.prometheus_endpoint}"

  json_data {
    http_method     = "POST"
    sigv4_auth      = true
    sigv4_auth_type = "default"
    sigv4_region    = var.region
  }
}

resource "grafana_folder" "kubernetes" {
  title = "Kubernetes"
}

resource "grafana_folder" "IPFS_Elastic_Provider" {
  title = "IPFS Elastic Provider"
}

resource "grafana_dashboard" "id_dashboards" { # TODO: It was required to inform config_json even with id
  for_each = { for dashboard_id in var.grafana_dashboards_ids : dashboard_id => dashboard_id }
  folder   = grafana_folder.kubernetes.id
  config_json = jsonencode({
    id = each.value
    title         = "data_source_dashboards 1"
    tags          = ["data_source_dashboards"]
    timezone      = "browser"
    schemaVersion = 16
  })
}

resource "grafana_dashboard" "file_dashboards" {
  #   for_each =   fileset("${path.module}/files", "*") 
  for_each    = fileset("dashboards", "*.json")
  folder      = grafana_folder.IPFS_Elastic_Provider.id
  config_json = file("dashboards/${each.value}")
}

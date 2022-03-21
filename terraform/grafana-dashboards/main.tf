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

provider "grafana" {
  url  = var.grafana_url # TODO: Can I get that from remote state?
  auth = var.grafana_auth
}

resource "grafana_data_source" "prometheus" {
  type = "prometheus"
  name = "amp"
  url  = var.prometheus_url # TODO: Get from remote state!

  json_data {
    http_method     = "POST"
    sigv4_auth      = true
    sigv4_auth_type = "default"
    sigv4_region    = var.region
  }
}

# I THINK that data_source from CloudWatch already comes setup by default, but let's see...

resource "grafana_folder" "IPFS_Elastic_Provider" {
  title = "IPFS Elastic Provider"
}

resource "grafana_dashboard" "id_dashboards" {
  for_each = var.grafana_dashboards_ids
  folder   = grafana_folder.IPFS_Elastic_Provider.id
  id       = each.value
}

resource "grafana_dashboard" "file_dashboards" {
  #   for_each =   fileset("${path.module}/files", "*") 
  for_each    = fileset("dashboards", "*.json")
  folder      = grafana_folder.IPFS_Elastic_Provider.id
  config_json = file("dashboards/${each.value}")
}

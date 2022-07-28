terraform {
  backend "s3" {
    profile        = "ipfs"
    bucket         = "ipfs-elastic-provider-terraform-state"
    dynamodb_table = "ipfs-elastic-provider-terraform-state-lock"
    region         = "us-west-2"
    key            = "terraform.aws-prometheus.tfstate"
    encrypt        = true
  }

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
      version = "~> 4.2"
    }
  }
  required_version = ">= 1.0.0"
}

data "terraform_remote_state" "peer" {
  backend = "s3"
  config = {
    bucket = "ipfs-elastic-provider-terraform-state"
    key    = "terraform.peer.tfstate"
    region = "${var.region}"
  }
}

provider "aws" {
  region  = var.region
  default_tags {
    tags = {
      Team        = "NearForm"
      Project     = "IPFS-Elastic-Provider"
      Environment = "POC"
      Subsystem   = "Observability"
      ManagedBy   = "Terraform"
    }
  }
}

provider "kubernetes" {
  host = var.host == "" ? data.terraform_remote_state.peer.outputs.host : var.host
  cluster_ca_certificate = base64decode(var.cluster_ca_cert == "" ? data.terraform_remote_state.peer.outputs.cluster_ca_certificate : var.cluster_ca_cert)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name == "" ? data.terraform_remote_state.peer.outputs.cluster_id : var.cluster_name]
    command     = "aws"
  }
}

resource "aws_prometheus_workspace" "ipfs_elastic_provider" {
  alias = "ipfs-elastic-provider"
}

resource "aws_sns_topic" "alerts_topic" {
  name     = "alerts-topic"
}

resource "aws_prometheus_alert_manager_definition" "alerts" {
  workspace_id = aws_prometheus_workspace.ipfs_elastic_provider.id
  definition   = <<EOF
template_files:
  default_template: |
    {{ define "sns.default.subject" }}[{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}]{{ end }}
    {{ define "__alertmanager" }}AlertManager{{ end }}
    {{ define "__alertmanagerURL" }}{{ .ExternalURL }}/#/alerts?receiver={{ .Receiver | urlquery }}{{ end }}
alertmanager_config: |
  global:
  templates:
    - 'default_template'
  route:
    receiver: default
  receivers:
    - name: 'default'
      sns_configs:
      - topic_arn: ${aws_sns_topic.alerts_topic.arn}
        sigv4:
          region: us-west-2
        attributes:
          key: severity
          value: SEV2
EOF
}

resource "aws_prometheus_rule_group_namespace" "alert_group" {
  name         = "rules"
  workspace_id = aws_prometheus_workspace.ipfs_elastic_provider.id
  data         = file("alerts/alert.rules.yaml")
}
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
  profile = var.profile
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

resource "aws_grafana_workspace" "ipfs_elastic_provider" {
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

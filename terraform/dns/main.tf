terraform {
  backend "s3" {
    profile        = "ipfs"
    bucket         = "ipfs-elastic-provider-terraform-state"
    dynamodb_table = "ipfs-elastic-provider-terraform-state-lock"
    region         = "us-west-2"
    key            = "terraform.dns.tfstate"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.0.0"
}

data "terraform_remote_state" "indexing" {
  backend = "s3"
  config = {
    bucket = "ipfs-elastic-provider-terraform-state"
    key    = "terraform.indexing.tfstate"
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
      Subsystem   = "DNS"
      ManagedBy   = "Terraform"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

module "dns_route53" {
  source                          = "../modules/dns-route53"
  existing_zone                   = var.existing_aws_zone
  domain_name                     = var.aws_domain_name
  subdomains_bitwsap_loadbalancer = var.subdomains_bitwsap_loadbalancer
  subdomain_apis                  = var.subdomain_apis
  bitswap_load_balancer_hostname  = var.bitswap_load_balancer_hostname
  api_gateway = {
    api_id     = data.terraform_remote_state.indexing.outputs.api_id
    stage_name = data.terraform_remote_state.indexing.outputs.stage_name
  }
}

module "dns_cloudflare" {
  source = "../modules/dns-cloudflare"
  records = [
    # {
    #   zone_id = var.cloudflare_zone_id
    #   name    = "*.${var.cloudflare_domain_name}"
    #   value   = "${var.aws_domain_name}"
    # },
    {
      zone_id = var.cloudflare_zone_id
      name    = "${var.subdomain_apis}.${var.cloudflare_domain_name}"
      value   = "${var.subdomain_apis}.${var.aws_domain_name}"
    },
  ]
}

module "dns-cloudflare-apig-domain" {
  source      = "../modules/dns-cloudflare-apig-domain"
  domain_name = var.cloudflare_domain_name
  subdomain   = "${var.subdomain_apis}.${var.cloudflare_domain_name}"
  zone_id     = var.cloudflare_zone_id

  api_gateway = {
    api_id     = data.terraform_remote_state.indexing.outputs.api_id
    stage_name = data.terraform_remote_state.indexing.outputs.stage_name
  }
}

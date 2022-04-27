terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
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

module "dns_route53" {
  source                            = "../modules/dns-route53"
  existing_zone                     = var.existing_aws_zone
  domain_name                       = var.aws_domain_name
  subdomains_bitwsap_loadbalancer   = var.subdomains_bitwsap_loadbalancer
  bitswap_load_balancer_dns         = var.bitswap_load_balancer_dns
  bitswap_load_balancer_hosted_zone = var.bitswap_load_balancer_hosted_zone
}

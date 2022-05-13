terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

locals {
  bitswap_loadbalancer_domain = "${var.subdomains_bitwsap_loadbalancer}.${var.aws_domain_name}"
}

data "aws_route53_zone" "hosted_zone" { # Existing zone
  count = var.existing_aws_zone ? 1 : 0
  name  = var.aws_domain_name
}

resource "aws_route53_zone" "hosted_zone" { # Non existing zone
  count = var.existing_aws_zone ? 0 : 1
  name  = var.aws_domain_name
}

resource "aws_route53_record" "peer_bitswap_load_balancer" {
  zone_id = var.existing_aws_zone ? data.aws_route53_zone.hosted_zone[0].zone_id : aws_route53_zone.hosted_zone[0].zone_id
  name    = local.bitswap_loadbalancer_domain
  type    = "A"

  alias {
    name                   = var.bitswap_load_balancer_dns
    zone_id                = var.bitswap_load_balancer_hosted_zone
    evaluate_target_health = true
  }
}

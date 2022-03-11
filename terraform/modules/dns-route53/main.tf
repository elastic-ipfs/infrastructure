terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

data "aws_route53_zone" "hosted_zone" {
  count = var.existing_zone ? 1 : 0
  name  = var.domain_name
}

resource "aws_route53_zone" "hosted_zone" {
  count = var.existing_zone ? 0 : 1
  name  = var.domain_name
}

resource "aws_route53_record" "peer_bitswap_load_balancer" {
  zone_id = var.existing_zone ? data.aws_route53_zone.hosted_zone[0].zone_id : aws_route53_zone.hosted_zone[0].zone_id
  name    = "${var.subdomains_bitwsap_loadbalancer}.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [var.bitswap_load_balancer_hostname]
}

### API Gateway
resource "aws_api_gateway_domain_name" "api" {
  domain_name              = local.api_domain
  regional_certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "api" {
  api_id      = var.api_gateway.api_id
  stage_name  = var.api_gateway.stage_name
  base_path   = var.api_gateway.stage_name
  domain_name = aws_api_gateway_domain_name.api.domain_name
}

resource "aws_route53_record" "api" {
  name    = aws_api_gateway_domain_name.api.domain_name
  type    = "A"
  zone_id = var.existing_zone ? data.aws_route53_zone.hosted_zone[0].zone_id : aws_route53_zone.hosted_zone[0].zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.api.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.api.regional_zone_id
  }
}

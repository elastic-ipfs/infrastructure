## TODO: Delete route53 usage and current AWS domain to centralize DNS handling in CF
## This can be done after https://filecoinproject.slack.com/archives/C02BZPRS9HP/p1660156558258439?thread_ts=1660147647.860729&cid=C02BZPRS9HP
locals {
  bitswap_loadbalancer_domain = "${var.deprecated_route53_subdomains_bitwsap_loadbalancer}.${var.aws_domain_name}"
}

data "aws_route53_zone" "hosted_zone" { # Existing zone
  count = var.create_zone ? 0 : 1
  name  = var.aws_domain_name
}

resource "aws_route53_zone" "hosted_zone" { # Non existing zone
  count = var.create_zone ? 1 : 0
  name  = var.aws_domain_name
}

resource "aws_route53_record" "peer_bitswap_load_balancer" {
  zone_id = var.create_zone ? aws_route53_zone.hosted_zone[0].zone_id : data.aws_route53_zone.hosted_zone[0].zone_id
  name    = local.bitswap_loadbalancer_domain
  type    = "A"

  alias {
    name                   = var.bitswap_peer_record_value
    zone_id                = var.bitswap_load_balancer_hosted_zone
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "peer_bitswap_load_balancer_ipv6" {
  zone_id = var.create_zone ? aws_route53_zone.hosted_zone[0].zone_id : data.aws_route53_zone.hosted_zone[0].zone_id
  name    = local.bitswap_loadbalancer_domain
  type    = "AAAA"

  alias {
    name                   = var.bitswap_peer_record_value
    zone_id                = var.bitswap_load_balancer_hosted_zone
    evaluate_target_health = true
  }
}

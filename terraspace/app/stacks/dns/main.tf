terraform {
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

data "cloudflare_zone" "dns" {
  name = var.cf_domain_name
}

resource "cloudflare_record" "bitswap_peer" {
  zone_id = data.cloudflare_zone.dns.id
  name    = var.bitswap_peer_record_name
  value   = var.bitswap_peer_record_value
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

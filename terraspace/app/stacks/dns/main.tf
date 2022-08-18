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

resource "cloudflare_record" "bitswap_peer_dnsaddr4" {
  zone_id = data.cloudflare_zone.dns.id
  name    = "_dnsaddr.${var.bitswap_peer_record_name}"
  value   = "dnsaddr=/dns4/${local.multiaddr_dnsaddress_sufix}"
  type    = "TXT"
  proxied = true 
  ttl     = 1
}

resource "cloudflare_record" "bitswap_peer_dnsaddr6" {
  zone_id = data.cloudflare_zone.dns.id
  name    = "_dnsaddr.${var.bitswap_peer_record_name}"
  value   = "dnsaddr=/dns6/${local.multiaddr_dnsaddress_sufix}"
  type    = "TXT"
  proxied = true 
  ttl     = 1
}

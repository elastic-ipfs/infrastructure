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

## TODO: Export Cert (Maybe need to create cert as well if doesn't exist yet)
## Cert specific for that subdomain or *? Ideally generate a more specific one (And that might even be easier for managing and importing to AWS)

resource "cloudflare_record" "bitswap_peer" {
  zone_id  = data.cloudflare_zone.dns.id
  name     = var.bitswap_peer_record.name
  value    = var.bitswap_peer_record.value
  proxied = true   
  type = "CNAME"
  ttl     = 1 # Proxied # TODO: Should I keep it as is? Maybe there are cost savings by increasing
}

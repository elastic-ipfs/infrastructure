terraform {
  backend "s3" {
    profile        = "ipfs"
    bucket         = "ipfs-elastic-provider-terraform-state"
    dynamodb_table = "ipfs-elastic-provider-terraform-state-lock"
    region         = "us-west-2"
    key            = "terraform.dns-cloudflare.tfstate"
    encrypt        = true
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_record" "record_cname" {
  zone_id = var.record.zone_id
  name    = var.record.name
  value   = var.record.value
  # proxied = true   ## ??
  type    = "CNAME"
  # ttl     = 1 # Proxied
  ttl     = 3600
}

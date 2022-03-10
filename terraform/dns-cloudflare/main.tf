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
  for_each = { for record in var.records : record.name => record }
  zone_id  = each.value.zone_id
  name     = each.value.name
  value    = each.value.value
  # proxied = true   ## ??
  type = "CNAME"
  # ttl     = 1 # Proxied
  ttl = 3600
}

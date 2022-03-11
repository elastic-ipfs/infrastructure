terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

# resource "cloudflare_record" "record_cname" {
#   for_each = { for record in var.records : record.name => record }
#   zone_id  = each.value.zone_id
#   name     = each.value.name
#   value    = each.value.value
#   type = "CNAME"
#   ttl = 3600
# }

resource "cloudflare_record" "record_cname_proxied" {
  for_each = { for record in var.records : record.name => record }
  zone_id  = each.value.zone_id
  name     = each.value.name
  value    = each.value.value
  proxied = true   
  type = "CNAME"
  ttl     = 1 # Proxied
}

output "bitswap_loadbalancer_domain" {
  value       = "${cloudflare_record.bitswap_peer.name}.${data.cloudflare_zone.dns.name}"
  description = "Domain name for bitswap peer"
}

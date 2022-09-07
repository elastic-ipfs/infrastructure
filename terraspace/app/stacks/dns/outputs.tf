output "bitswap_loadbalancer_domain" {
  value       = cloudflare_record.bitswap_peer.hostname
  description = "Domain name for bitswap peer"
}

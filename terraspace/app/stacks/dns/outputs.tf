output "bitswap_loadbalancer_domain" {
  value       = aws_route53_record.peer_bitswap_load_balancer.name
  description = "Domain name for bitswap peer"
}

# TODO: Replace with new domain to start advertising new address through publishing subsys. Will do after confirming with #storetheindex
output "bitswap_loadbalancer_domain" {
  value       = aws_route53_record.peer_bitswap_load_balancer.name
  description = "Domain name for bitswap peer"
}

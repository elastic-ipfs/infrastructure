output "bitswap_load_balancer_hostname" {
  value = kubernetes_service.bitswap_service.status.0.load_balancer.0.ingress.0.hostname 
}

# output "provider_load_balancer_hostname" {
#   value = kubernetes_service.provider_service.status.0.load_balancer.0.ingress.0.hostname 
# }

output "host" {
  value = var.host
}

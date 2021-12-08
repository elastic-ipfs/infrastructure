output "load_balancer_hostname" {
  value = kubernetes_service.service.status.0.load_balancer.0.ingress.0.hostname
}

output "cluster_ca_certificate" {
  value = var.cluster_ca_certificate
}

output "host" {
  value = var.host
}


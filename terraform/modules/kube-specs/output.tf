output "load_balancer_hostname" {
  # value = kubernetes_ingress.aws_ipfs_ingress.status.0.load_balancer.0.ingress.0.hostname # TODO: Fix
  value = "whatevernow"
}

output "cluster_ca_certificate" {
  value = var.cluster_ca_certificate
}

output "host" {
  value = var.host
}

output "load_balancer_hostname" {
  value = kubernetes_ingress_v1.aws_ipfs_ingress.status.0.load_balancer.0.ingress.0.hostname # TODO: Fix. Probably this will have to be from 'data'
  # value = "whatevernow"
}

output "cluster_ca_certificate" {
  value = var.cluster_ca_certificate
}

output "host" {
  value = var.host
}

### WARNING: Security: Do not expose that in a production environment. This is just for testing.
output "eks_token" {
  value = data.aws_eks_cluster_auth.eks.token
  sensitive = true
}
output "eks_host" {
  value = data.aws_eks_cluster.eks.endpoint
}

output "eks_cluster_ca_certificate" {
  value = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
}

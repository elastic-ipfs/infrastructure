output "eks_token" {
  value = data.aws_eks_cluster_auth.eks.token
  sensitive = true
}
output "eks_host" {
  value = data.aws_eks_cluster.eks.endpoint
  sensitive = true
}

output "eks_cluster_ca_certificate" {
  value = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  sensitive = true
}

output "iam_roles" {
  value = module.kube-base-components.iam_roles
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}


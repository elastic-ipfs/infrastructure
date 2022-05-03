output "host" {
  value = data.aws_eks_cluster.eks.endpoint  
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_ca_certificate" {
  value = data.aws_eks_cluster.eks.certificate_authority[0].data
}

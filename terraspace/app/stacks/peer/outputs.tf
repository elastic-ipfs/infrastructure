output "host" {
  value       = data.aws_eks_cluster.eks.endpoint
  description = "EKS control plane API server endpoint"
}

output "cluster_oidc_issuer_url" {
  value       = module.eks.cluster_oidc_issuer_url
  description = "Used for allowing Kubernetes to manage AWS resources"
}

output "cluster_id" {
  value       = module.eks.cluster_id
  description = "EKS cluster name"
}

output "cluster_ca_certificate" {
  value       = data.aws_eks_cluster.eks.certificate_authority[0].data
  description = "Base64 encoded Certificate Authority PEM for EKS"
}

output "eks_oidc_provider_arn" {
  value       = module.eks.oidc_provider_arn
  sensitive   = true
  description = "The ARN of the OIDC Provider if enable_irsa = true"
}

output "oidc_provider" {
  value       = module.eks.oidc_provider
  sensitive   = true
  description = "The OpenID Connect identity provider (issuer URL without leading https://)"
}
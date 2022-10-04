variable "service_account_name" {
  type    = string
  default = "iamproxy-ingest-service-account"
  description = "Prometheus service account name"
}

variable "namespace" {
  type    = string
  default = "prometheus"
  description = "Prometheus kubernetes namespace"
}

variable "cluster_id" {
  type        = string
  description = "This ID is managed by the peer stack. The same as EKS cluster name"
}

variable "oidc_provider" {
  type = string
  description = "The OpenID Connect identity provider (issuer URL without leading https://)"
}

variable "eks_oidc_provider_arn" {
  type = string
  description = "The ARN of the OIDC Provider if enable_irsa = true"
}

variable "host" {
  type        = string
  description = "This URL is managed by the peer stack. EKS control plane API server endpoint"
}

variable "cluster_ca_certificate" {
  type        = string
  description = "This certificate is managed by the peer stack. Base64 encoded Certificate Authority PEM for EKS"
}

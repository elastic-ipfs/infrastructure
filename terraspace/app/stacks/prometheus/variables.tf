variable "service_account_name" {
  type    = string
  default = "iamproxy-ingest-service-account"
}

variable "namespace" {
  type    = string
  default = "prometheus"
}

variable "region" {
  type = string
}

variable "remotewrite_url" {
  type = string
}

variable "cluster_id" {
  type        = string
  description = "This ID is managed by the peer stack. The same as EKS cluster name"
}

variable "host" {
  type        = string
  description = "This URL is managed by the peer stack. EKS control plane API server endpoint"
}

variable "cluster_ca_certificate" {
  type        = string
  description = "This certificate is managed by the peer stack. Base64 encoded Certificate Authority PEM for EKS"
}

variable "role_arn" {
  type = string
}
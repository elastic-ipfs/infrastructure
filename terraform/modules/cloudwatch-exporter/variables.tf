variable "cluster_oidc_issuer_url" {
  type = string
}

variable "host" {
  type = string
}

variable "token" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

variable "region" {
  type = string
}

variable "deploy_cloudwatch_exporter" {
  description = "Whether to deploy or not the deploy_cloudwatch_exporter to the cluster"
  type        = bool
  default     = true
}


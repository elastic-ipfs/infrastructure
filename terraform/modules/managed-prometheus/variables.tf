variable "service_account_name" {
  type = string
  default = "amp-iamproxy-ingest-service-account"
}

variable "namespace" {
  type = string
  default = "prometheus"
}

variable "cluster_name" {
  type = string
}

variable "cluster_oidc_issuer_url" {
  type = string
}

variable "region" {
  type = string
}

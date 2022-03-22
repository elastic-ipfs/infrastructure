variable "service_account_name" {
  type    = string
  default = "amp-iamproxy-ingest-service-account"
}

variable "namespace" {
  type    = string
  default = "prometheus"
}

variable "cluster_name" {
  type = string
  default = ""
}

variable "host" {
  type    = string
  default = ""
}

variable "cluster_oidc_issuer_url" {
  type    = string
  default = ""
}

variable "profile" {
  type = string
}

variable "region" {
  type = string
}

variable "service_account_name" {
  type = string
  default = "cluster-autoscaler"
}

variable "namespace" {
  type = string
  default = "kube-system"
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

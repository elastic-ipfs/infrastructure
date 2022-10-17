variable "service_account_name" {
  type    = string
  default = "cluster-autoscaler"
}

variable "namespace" {
  type    = string
  default = "kube-system"
}

variable "cluster_name" {
  type = string
}

variable "cluster_oidc_issuer_url" {
  type        = string
  description = "Used for allowing Kubernetes to manage AWS resources"
}

variable "region" {
  type        = string
  description = "Region where the resources will be deployed"
}

variable "cluster_autoscaler_version" {
  type        = string
  description = "Version for cluster autoscaler operator"
}

variable "cluster_autoscaler_role_name" {
  type        = string
  description = "Name for cluster autoscaler role"
}

variable "cluster_autoscaler_policy_name" {
  type        = string
  description = "Name for policy which allows cluster autoscaler operator to handle AWS node group"
}

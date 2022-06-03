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
  type = string
}

variable "region" {
  type = string
}

variable "cluster_autoscaler_role_name" {
  type        = string
  description = "Name for cluster autoscaler role"
}

variable "cluster_autoscaler_policy_name" {
  type        = string
  description = "Name for policy which allows cluster autoscaler operator to handle AWS node group"
}

variable "account_id" {
  type        = string
  description = "AWS account ID"
}

variable "asg_names" {
  type = string
  description = "Auto Scaling Group Name"
}

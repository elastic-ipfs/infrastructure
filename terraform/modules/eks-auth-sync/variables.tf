variable "region" {
  description = "Region where the resources will be deployed"
  type        = string
}

variable "cluster_name" {
  description = "Will be used for configuring IAM scanner"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  type = string
}

variable "namespace" {
  description = "Which namespace to deploy eks-auth-sync"
  type = string
  default = "kube-system"
}

variable "deploy_cluster_autoscaler" {
  description = "Whether to deploy or not the cluster autoscaler daemon on the cluster"
  type        = bool
  default     = true
}

variable "eks_auth_sync_policy_name" {
  type = string
  default = "eks-auth-sync-policy"
}

variable "eks_auth_sync_role_name" {
  type = string
  default = "eks-auth-sync-role"
}

variable "cronjob_schedule" {
  type = string
  default = "*/15 * * * *"
}

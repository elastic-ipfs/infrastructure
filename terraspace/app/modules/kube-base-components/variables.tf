variable "cluster_id" {
  type = string
}

variable "cluster_oidc_issuer_url" {
  type = string
}

variable "region" {
  type = string
}

variable "config_bucket_name" {
  type        = string
  description = "Bucket for storing CAR files"
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

variable "service_account_roles" {
  type = map(object({
    service_account_name      = string,
    service_account_namespace = string,
    role_name                 = string
    policies_list = list(object({
      name = string,
      arn  = string,
    }))
  }))
}

variable "eks_auth_sync_policy_name" {
  type    = string
  default = "eks-auth-sync-policy"
}

variable "eks_auth_sync_role_name" {
  type    = string
  default = "eks-auth-sync-role"
}

variable "deploy_eks_auth_sync" {
  description = "Whether to deploy or not the eks_auth_sync daemon to the cluster"
  type        = bool
  default     = true
}

variable "deploy_argocd" {
  description = "Whether to deploy or not the argocd to the cluster"
  type        = bool
  default     = true
}

variable "deploy_cloudwatch_exporter" {
  description = "Whether to deploy or not the cloudwatch_exporter to the cluster"
  type        = bool
  default     = true
}

variable "deploy_cluster_autoscaler" {
  description = "Whether to deploy or not the cluster_autoscaler to the cluster"
  type        = bool
  default     = true
}

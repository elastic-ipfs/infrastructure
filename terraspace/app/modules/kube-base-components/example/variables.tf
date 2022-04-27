variable "region" {
  type = string
}

variable "profile" {
  type = string
}

variable "accountId" {
  type = string
}

variable "config_bucket_name" {
  type    = string
}

variable "vpc" {
  type = object({
    name = string
  })
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "provider_ads_bucket_name" {
  type    = string
  description = "Bucket for storing provider files"
}

variable "eks_auth_sync_policy_name" {
  type = string
}

variable "eks_auth_sync_role_name" {
  type = string
}

variable "bitswap_role_name" {
  type = string
}

variable "deploy_eks_auth_sync" {
  type = bool
}

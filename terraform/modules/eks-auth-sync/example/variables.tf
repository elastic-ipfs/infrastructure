variable "region" {
  type = string
}

variable "profile" {
  type = string
}

variable "accountId" {
  type = string
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

variable "eks_auth_sync_policy_name" {
  type = string
}

variable "eks_auth_sync_role_name" {
  type = string
}

variable "cronjob_schedule" {
  type = string
}

variable "eks_admin_user_name" {
  type = string
}

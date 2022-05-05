variable "vpc" {
  type = object({
    name = string
  })
  description = "VPC for EKS worker nodes"
}

variable "cluster_name" {
  type    = string
  description = "EKS cluster name"
}

variable "region" {
  type    = string
  description = "VPC Gateways service names are composed using this region"
}

variable "cluster_version" {
  type    = string
  default = "1.21"
  description = "Kubernetes version"
}

variable "provider_ads_bucket_name" {
  type        = string
  description = "Bucket for storing provider files"
}

variable "account_id" {
  type = string
  description = "AWS account ID"
}

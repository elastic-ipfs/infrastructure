variable "vpc" {
  type = object({
    name = string
  })
  default = {
    name = "test-ipfs-peer-subsys"
  }
}

variable "cluster_name" {
  type    = string
  default = "test-ipfs-peer-subsys"
}

variable "cluster_version" {
  type    = string
  default = "1.21"
}

variable "provider_ads_bucket_name" {
  type        = string
  default     = "ipfs-provider-ads"
  description = "Bucket for storing provider files"
}

variable "profile" {
  type = string
}

variable "region" {
  type = string
}

variable "accountId" {
  type = string
}

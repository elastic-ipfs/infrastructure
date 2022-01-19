variable "vpc" {
  type = object({
    name = string
  })
  default = {
    name = "test-ipfs-aws-peer-subsystem-vpc"
  }
}

variable "cluster_name" {
  type = string
  default = "test-ipfs-aws-peer-subsystem-eks"
}

variable "cluster_version" {
  type = string
  default = "1.21"
}

variable "config_bucket_name" {
  type    = string
  # default = "ipfs-peer-bitswap-config"
  default = "ipfs-peer-bitswap-config"
}

variable "provider_ads_bucket_name" {
  type    = string
  default = "ipfs-provider-ads"
  description = "Bucket for storing provider files"
}

variable "profile" {
  type = string
}

variable "region" {
  type = string
}
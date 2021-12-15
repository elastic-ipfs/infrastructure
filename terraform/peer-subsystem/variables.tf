variable "container_image" {
  type = string
  default = "ghcr.io/web3-storage/aws-ipfs-bitswap-peer/app:latest"
}

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

variable "kubeconfig_output_path" {
  type = string
}

variable "peerConfigBucketName" {
  type    = string
  default = "ipfs-peer-bitswap-config"
  description = "Bucket for storing CAR files"
}

variable "ipfsProviderAds" {
  type    = string
  default = "ipfs-provider-ads"
  description = "Bucket for storing provider files"
}

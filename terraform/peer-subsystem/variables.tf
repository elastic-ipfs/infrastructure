variable "peer_container_image" {
  type = string
}

variable "provider_container_image" { 
  type = string
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

variable "configBucketName" {
  type    = string
  # default = "ipfs-peer-bitswap-config"
  default = "ipfs-peer-bitswap-config"
}

variable "ipfsProviderAds" {
  type    = string
  # default = "ipfs-provider-ads"
  default = "ipfs-provider-ads"
  description = "Bucket for storing provider files"
}

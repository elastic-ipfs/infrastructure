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

variable "eks-cluster" {
  type = object({
    name = string
    version = string
  })
   default = {
    name = "test-ipfs-aws-peer-subsystem-eks"
    version = "1.21"
  }
}

variable "kubeconfig_output_path" {
  type = string
}

variable "peerConfigBucketName" {
  type    = string
  default = "ipfs-peer-bitswap-config"
  description = "Bucket for storing CAR files"
}

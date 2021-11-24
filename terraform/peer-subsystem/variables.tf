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
    version = "1.20" # TODO: Upgrade to 1.21
  }
}

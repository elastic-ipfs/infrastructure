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
  })
   default = {
    name = "test-ipfs-aws-peer-subsystem-eks"
  }
}

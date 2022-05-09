variable "vpc" {
  type = object({
    name                 = string
    cidr                 = string
    private_subnets      = list(string)
    public_subnets       = list(string)
    enable_nat_gateway   = bool
    single_nat_gateway   = bool
    enable_dns_hostnames = bool
  })
  description = "VPC for EKS worker nodes"
}

variable "eks" {
  type = object({
    name    = string
    version = string
    eks_managed_node_groups = object({
      desired_size   = number
      min_size       = number
      max_size       = number
      instance_types = list(string)
    })
  })
  description = "EKS cluster"
}

variable "region" {
  type        = string
  description = "VPC Gateways service names are composed using this region"
}

variable "account_id" {
  type        = string
  description = "AWS account ID"
}

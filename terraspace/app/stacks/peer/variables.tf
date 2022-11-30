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
      name           = string
      desired_size   = number
      min_size       = number
      max_size       = number
      instance_types = list(string)
    })
  })
  description = "EKS cluster"
}

variable "account_id" {
  type        = string
  description = "AWS account ID"
}

variable "enable_troubleshooting_sg_rules" {
  type        = bool
  default     = false
  description = "Defines if egress security group rules should be defined to allow troubleshooting to the internet"
}

variable "config_table" {
  type = object({
    name     = string
    hash_key = string
  })
  description = "This table is supposed to contain configuration key/value pairs"
}

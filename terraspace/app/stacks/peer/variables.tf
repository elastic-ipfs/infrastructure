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

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "region" {
  type        = string
  description = "VPC Gateways service names are composed using this region"
}

variable "cluster_version" {
  type        = string
  default     = "1.21"
  description = "Kubernetes version"
}

variable "account_id" {
  type        = string
  description = "AWS account ID"
}

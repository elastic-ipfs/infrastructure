variable "domain_name" {
  type = string
  # default = "aws-ipfs.com"
  default = "franciscocardosotest.com"
}

variable "subdomain_loadbalancer" {
  type = string
  default = "cluster"
  description = "Name for a load balancer subdomain"
}

variable "subdomain_apis" {
  type = string
  default = "api.uploader"
  description = "Name for a API Gateway subdomain"
}

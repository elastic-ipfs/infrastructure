variable "hosted_zone_name" {
  type = string
  default = "aws-ipfs.com"
  description = "Name for a hosted zone"
}

variable "subdomain_loadbalancer" {
  type = string
  default = "peer"
  description = "Name for a load balancer subdomain"
}

variable "domain_name" {
  type = string
  # default = "aws-ipfs.com"
  default = "franciscocardosotest.com"
}

variable "subdomains_loadbalancer" {
  type = list(string)
  default = ["peer", "provider"]
  description = "List of subdomains that will be handled by ingress"
}

variable "subdomain_apis" {
  type = string
  default = "api.uploader"
  description = "Name for a API Gateway subdomain"
}

variable "profile" {
  type = string
}

variable "domain_name" {
  type    = string
  default = "provider.dag.house"
}

variable "subdomains_bitwsap_loadbalancer" {
  default     = "peer"
  description = "Subdomains that will be handled by peer svc loadbalancer"
}

variable "subdomain_apis" {
  type        = string
  default     = "api.uploader"
  description = "Name for a API Gateway subdomain"
}

variable "bitswap_load_balancer_hostname" {
  type        = string
  description = "Bitswap LoadBalancer URL"
}

variable "region" {
  type = string
}

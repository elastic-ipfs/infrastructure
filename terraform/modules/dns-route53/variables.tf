variable "existing_zone" {
  type = bool
}

variable "domain_name" {
  type = string
}

variable "subdomains_bitwsap_loadbalancer" {
  description = "Subdomains that will be handled by peer svc loadbalancer"
}

variable "subdomain_apis" {
  type        = string
  description = "Name for a API Gateway subdomain"
}

variable "bitswap_load_balancer_hostname" {
  type        = string
  description = "Bitswap LoadBalancer URL"
}

variable "api_gateway" {
  type = object({
    api_id     = string
    stage_name = string
  })
}

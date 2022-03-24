variable "existing_zone" {
  type = bool
}

variable "domain_name" {
  type = string
}

variable "subdomains_bitwsap_loadbalancer" {
  description = "Subdomains that will be handled by peer svc loadbalancer"
}
variable "bitswap_load_balancer_hostname" {
  type        = string
  description = "Bitswap LoadBalancer URL"
}

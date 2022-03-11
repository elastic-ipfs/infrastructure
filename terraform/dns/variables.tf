variable "profile" {
  type = string
}

variable "region" {
  type = string
}

variable "cloudflare_api_token" {
  type = string
}

variable "existing_aws_zone" {
  type    = bool
}

variable "aws_domain_name" {
  type    = string
}

variable "cloudflare_zone_id" {
  type    = string
}

variable "cloudflare_domain_name" {
  type    = string
}

variable "subdomain_apis" {
  type        = string
  description = "Name for a API Gateway subdomain"
}

variable "subdomains_bitwsap_loadbalancer" {
  description = "Subdomains that will be handled by peer svc loadbalancer"
}

variable "bitswap_load_balancer_hostname" {
  type        = string
  description = "Bitswap LoadBalancer URL"
}

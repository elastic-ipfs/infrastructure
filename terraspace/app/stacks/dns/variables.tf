### Deprecated
variable "create_zone" {
  type        = bool
  description = "If true, creates a managed hosted zone"
}

variable "aws_domain_name" {
  type        = string
  description = "The name of the hosted zone to either create or lookup"
}

variable "deprecated_route53_subdomains_bitwsap_loadbalancer" {
  type        = string
  description = "Subdomains that will be handled by peer svc loadbalancer"
}
###

variable "bitswap_load_balancer_hosted_zone" {
  type        = string
  description = "Bitswap LoadBalancer Hosted Zone. This load balancer is created and managed by Kubernetes"
}

variable "cf_domain_name" {
  type = string
  description = "DNS Zone name"
}

variable "bitswap_peer_record_name" {
  type = string
  description = "Bitswap Peer record name"
}

variable "bitswap_peer_record_value" {
  type = string
  description = "Bitswap Peer record value. This load balancer is created and managed by Kubernetes"
}

variable "cf_domain_name" {
  type = string
  description = "DNS Zone name"
}

variable "bitswap_peer_record" {
  type = object({
    name    = string
    value   = string
  })
  description = "Bitswap Peer record information"
}

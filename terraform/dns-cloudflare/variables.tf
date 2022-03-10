variable "cloudflare_api_token" {
  type = string
}

variable "record" {
  type = object({
    zone_id = string
    name  = string
    value = string
  })
}

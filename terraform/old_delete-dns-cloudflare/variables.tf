variable "cloudflare_api_token" {
  type = string
}

variable "records" {
  type = list(object({
    zone_id = string
    name  = string
    value = string
  }))
}

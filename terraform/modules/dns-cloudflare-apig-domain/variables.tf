variable "domain_name" {
  type = string
}

variable "subdomain" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "api_gateway" {
  type = object({
    api_id     = string
    stage_name = string
  })
}

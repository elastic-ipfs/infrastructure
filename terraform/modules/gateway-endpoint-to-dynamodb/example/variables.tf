variable "region" {
  type = string
}

variable "profile" {
  type = string
}

variable "vpc" {
  type = object({
    name = string
  })
}

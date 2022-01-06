variable "region" {
  type = string
}

variable "profile" {
  type = string
}

variable "lambda" {
  type = object({
    name = string
  })
}

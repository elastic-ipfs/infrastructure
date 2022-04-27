variable "region" {
  type = string
}

variable "profile" {
  type = string
}

variable "blocks_table" {
  type = object({
    name = string
  })
}

variable "cars_table" {
  type = object({
    name = string
  })
}

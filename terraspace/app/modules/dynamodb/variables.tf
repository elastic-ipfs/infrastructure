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

variable "target_key_arn" {
  type = string
  description = "KMS alias name for this module"
}

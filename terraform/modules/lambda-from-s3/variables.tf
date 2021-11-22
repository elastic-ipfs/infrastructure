variable "bucket" {
  type = object({
    bucket = string
    arn    = string
    id     = string
  })
}

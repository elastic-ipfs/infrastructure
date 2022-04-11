variable "profile" {
  type = string
}

variable "region" {
  type = string
}

variable "account-id" {
  type = string
}

variable "bucket" {
  type = object({
    bucket = string
    arn    = string
    id     = string
  })
}

variable "lambda_image"{
  type = string
}

variable "lambdaName" {
  type = string
  default = "bucket-to-indexer"
}
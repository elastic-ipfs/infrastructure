variable "carsBucketName" {
  type        = string
  default     = "ipfs-cars"
  description = "Bucket for storing CAR files"
}

variable "profile" {
  type = string
}

variable "region" {
  type = string
}
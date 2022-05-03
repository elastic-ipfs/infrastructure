variable "vpc" {
  type = object({
    name = string
  })
}

variable "cluster_name" {
  type    = string
}

variable "cluster_version" {
  type    = string
  default = "1.21"
}

variable "provider_ads_bucket_name" {
  type        = string
  description = "Bucket for storing provider files"
}

variable "account_id" {
  type = string
}

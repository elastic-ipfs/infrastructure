variable "provider_ads_bucket_name" {
  type        = string
  default     = "ipfs-advertisement"
  description = "Bucket for storing advertisement files"
}

variable "profile" {
  type = string
}

variable "region" {
  type = string
}

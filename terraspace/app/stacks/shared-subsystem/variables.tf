variable "carsBucketName" {
  type        = string
  default     = "ipfs-cars"
  description = "Bucket for storing CAR files"
}

variable "config_bucket_name" {
  type    = string
  default = "ipfs-peer-bitswap-config"
}

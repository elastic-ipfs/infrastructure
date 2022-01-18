variable "cluster_id" {
  type = string
}

variable "cluster_oidc_issuer_url" {
  type = string
}
variable "config_bucket_name" {
  type        = string
  description = "Bucket for storing CAR files"
}

variable "host" {
  type = string
}

variable "token" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

variable "service_account_roles" {
  type = map(object({
    service_account_name      = string,
    service_account_namespace = string,
    role_name                 = string
    policies_list = list(object({
      name = string,
      arn  = string,
    }))
  }))
}

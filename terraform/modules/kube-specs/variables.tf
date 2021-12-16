variable "peer_container_image" {
  type = string
}

variable "provider_container_image" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "cluster_oidc_issuer_url" {
  type = string
}

variable "cluster_oidc_provider_arn" {
  type = string
}

variable "kubeconfig_output_path" {
  type = string
}

variable "aws_iam_role_policy_list" {
  type = list(object({
    name = string,
    arn  = string,
  }))
  description = "This list contains policies that will be attached to the current role"
}

variable "configBucketName" {
  type    = string
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

variable "sqs_queue" {
  type=string
}
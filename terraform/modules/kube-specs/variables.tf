variable "container_image" {
  type = string
}

variable "eks_cluster_id" {
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

variable "cluster_oidc_issuer_url" {
  type = string
}

variable "peerConfigBucketName" {
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

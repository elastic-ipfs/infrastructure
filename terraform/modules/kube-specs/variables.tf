variable "eks_cluster_id" {
  type = string
}

variable "eks_cluster_name" {
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

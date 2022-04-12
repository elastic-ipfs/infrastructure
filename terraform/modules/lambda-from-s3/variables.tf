variable "lambda_name" {
  type = string
}

variable "bucket" {
  type = object({
    bucket = string
    arn    = string
    id     = string
  })
}

variable "topic_url" {
  type = string
}

variable "aws_iam_role_policy_list" {
  type = list(object({
    name = string,
    arn  = string,
  }))
  description = "This list contains policies that will be attached to the current role"
}

variable "region" {
  type = string
}

variable custom_metrics {
  type = list(string)
  default = []
}

variable "lambda_image" {
  type = string
}

variable "lambda_memory" {
  type = string
}

variable "lambda_timeout" {
  type = string
}
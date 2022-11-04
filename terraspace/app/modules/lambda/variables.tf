variable "lambda" {
  type = object({
    name                  = string
    image_uri             = string
    environment_variables = map(string)
    memory_size           = number
    timeout               = number
    policies_list = list(object({
      name = string,
      arn  = string,
    }))
  })
}

variable "sns_topic_trigger_arns" {
  type        = list(string)
  description = "List of SNS topics arns which lambda should subscribe to"
  default     = []
}

variable "custom_metrics" {
  type    = list(string)
  default = []
}

variable "region" {
  type        = string
  description = "Region where the resources will be deployed"
}

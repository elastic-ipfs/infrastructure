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

variable "sns_topic" {
  type = string
  description = "Name of SNS topic which lambda should subscribe to"
}

variable "custom_metrics" {
  type    = list(string)
  default = []
}

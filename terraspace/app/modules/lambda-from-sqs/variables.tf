variable "sqs_trigger" {
  type = object({
    arn                                = string
    batch_size                         = number
    maximum_batching_window_in_seconds = number
  })
}


variable "lambda" {
  type = object({
    name                           = string
    image_uri                      = string
    environment_variables          = map(string)
    memory_size                    = number
    timeout                        = number
    reserved_concurrent_executions = number
    policies_list = list(object({
      name = string,
      arn  = string,
    }))
  })
}

variable "metrics_namespace" {
  type = string
}

variable "custom_metrics" {
  type    = list(string)
  default = []
}

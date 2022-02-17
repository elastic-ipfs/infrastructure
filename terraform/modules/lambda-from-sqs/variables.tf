variable "sqs_trigger" {
  type = object({
    arn                                = string
    batch_size                         = string
    maximum_batching_window_in_seconds = string
  })
}


variable "lambda" {
  type = object({
    name                  = string
    image_uri             = string
    environment_variables = map(string)
    memory_size = string
    timeout = string
    policies_list = list(object({
      name = string,
      arn  = string,
    }))
  })
}

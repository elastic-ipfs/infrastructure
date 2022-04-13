variable "lambda" {
  type = object({
    name                           = string
    image_uri                      = string
    environment_variables          = map(string)
    memory_size                    = number
    timeout                        = number
    policies_list = list(object({
      name = string,
      arn  = string,
    }))
  })
}

variable "bucket" {
  type = object({
    bucket = string
    arn    = string
    id     = string
  })
}


variable "region" {
  type = string
}

variable custom_metrics {
  type = list(string)
  default = []
}

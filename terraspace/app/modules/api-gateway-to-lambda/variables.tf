variable "lambda" {
  type = object({
    function_name = string
    invoke_arn    = string
  })
}

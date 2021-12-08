variable "aws_iam_role_policy_list" {
  type = list(object({
    name = string,
    arn  = string,
  }))
  description = "This list contains policies that will be attached to the current role"
}


variable "lambda" {
  type = object({
    function_name = string
    invoke_arn = string
  })
}

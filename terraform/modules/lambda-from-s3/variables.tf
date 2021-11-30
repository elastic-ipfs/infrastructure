variable "bucket" {
  type = object({
    bucket = string
    arn    = string
    id     = string
  })
}

# TODO: Loop para attachment
variable "aws_iam_role_policy_list" {
  # https://www.terraform.io/docs/language/values/variables.html
  type =  list(object({
    name = string,
    arn = string,
  }))
  # type = list # https://stackoverflow.com/questions/52119400/how-to-get-an-object-from-a-list-of-objects-in-terraform
  description = "This list contains policies that will be attached to the current role"
}

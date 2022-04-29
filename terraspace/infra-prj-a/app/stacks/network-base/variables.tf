variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_tags" {
  description = "Tags to associate to the VPC"
  type        = map(string)
  default     = {}
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "private_subnets" {
  type = map(object({
    name = string
    cidr = string
    az   = string
  }))
}

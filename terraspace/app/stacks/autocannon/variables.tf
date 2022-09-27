variable "subnet_id" {
  type        = string
  description = "ID of subnet where autocannon should run"
}

variable "security_group_id" {
  type        = string
  description = "ID of security group where autocannon should run"
}

variable "key_name" {
  type        = string
  description = "AWS key Pair name"
}

variable "ec2_instance_name" {
  type        = string
  description = "Name for the EC2 which will run bucket mirror"
}

variable "autocannon_ami_name" {
  type        = string
  description = "Name of image (AMI) which contains 'autocannon' prepared to run"
}

variable "policies_list" {
  type = list(object({
    name = string,
    arn  = string,
  }))
  description = "List of policies which are going to be attached to EC2 role"
}

variable "node_env" {
  type        = string
  description = "node_env environment variable value. Has effect on logs"
  default     = "production"
}

variable "log_level" {
  type        = string
  description = "which level of logs should be outputted"
  default     = "info"
}

variable "log_after_value_files" {
  type        = number
  description = "define after how many files to update run status in log"
}

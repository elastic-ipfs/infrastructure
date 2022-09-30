variable "subnet_id" {
  type        = string
  description = "ID of subnet where peer-e2e-testing should run"
}

variable "security_group_id" {
  type        = string
  description = "ID of security group where peer-e2e-testing should run"
}

variable "key_name" {
  type        = string
  description = "AWS key Pair name"
}

variable "ec2_instance_name" {
  type        = string
  description = "Name for the EC2 which will run bucket mirror"
}

variable "peer-e2e-testing_ami_name" {
  type        = string
  description = "Name of image (AMI) which contains 'peer-e2e-testing' prepared to run"
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

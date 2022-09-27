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

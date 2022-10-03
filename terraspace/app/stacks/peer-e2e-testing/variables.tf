variable "subnet_id" {
  type        = string
  description = "ID of subnet where peer_e2e_testing should run"
}

variable "security_group_id" {
  type        = string
  description = "ID of security group where peer_e2e_testing should run"
}

variable "key_name" {
  type        = string
  description = "AWS key Pair name"
}

variable "ec2_instance_name" {
  type        = string
  description = "Name for the EC2 which will run peer_e2e_testing"
}

variable "peer_e2e_testing_ami_name" {
  type        = string
  description = "Name of image (AMI) which contains 'peer_e2e_testing' prepared to run"
}

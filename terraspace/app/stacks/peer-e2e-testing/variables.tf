variable "subnet_id" {
  type        = string
  description = "ID of subnet where peer_e2e_testing should run"
}

variable "ec2_instance_name" {
  type        = string
  description = "Name for the EC2 which will run peer_e2e_testing"
}

variable "peer_e2e_testing_ami_name" {
  type        = string
  description = "Name of image (AMI) which contains 'peer_e2e_testing' prepared to run"
}

variable "s3_e2e_policy_write_name" {
  type        = string
  description = "Name of the s3 write policy"
}
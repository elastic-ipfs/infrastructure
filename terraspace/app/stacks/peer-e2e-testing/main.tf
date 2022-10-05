terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

data "aws_ami" "peer_e2e_testing" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.peer_e2e_testing_ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [local.aws_account_id] # PLNITRO
}

resource "aws_instance" "peer_e2e_testing_runner" {
  ami                    = data.aws_ami.peer_e2e_testing.id
  instance_type          = "t3.medium"
  subnet_id              = var.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = var.ec2_instance_name
  }

  volume_tags = {
    Name = "peer_e2e_testing"
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
}

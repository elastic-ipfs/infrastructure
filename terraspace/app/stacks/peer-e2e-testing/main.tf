terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

data "aws_availability_zones" "azs" {
  state = "available"
}

data "aws_ami" "peer-e2e-testing" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.peer-e2e-testing_ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [local.aws_account_id] # PLNITRO
}

resource "aws_instance" "peer-e2e-testing_runner" {
  ami                    = data.aws_ami.peer-e2e-testing.id
  instance_type          = "t2.medium"
  subnet_id              = var.subnet_id
  availability_zone      = data.aws_availability_zones.azs.names[0]
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = var.ec2_instance_name
  }

  volume_tags = {
    Name = "peer-e2e-testing"
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
}

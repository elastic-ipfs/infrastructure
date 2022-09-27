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

data "aws_ami" "autocannon" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.autocannon_ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [local.aws_account_id] # PLNITRO
}

resource "aws_instance" "autocannon_runner" {
  ami                    = data.aws_ami.autocannon.id
  instance_type          = "t2.medium"
  subnet_id              = var.subnet_id
  availability_zone      = data.aws_availability_zones.azs.names[0]
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = var.ec2_instance_name
  }

  root_block_device {
    delete_on_termination = false
    # If this instance is terminated, it will still be possible to get the latest 'NextContinuationToken' from persistent EBS.
    # It needs to be attached and mounted into a new instance for acessing its content.
  }

  volume_tags = {
    Name = "autocannon"
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
}

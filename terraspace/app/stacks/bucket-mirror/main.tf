terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

data "aws_vpc" "management_vpc" {
  id = var.management_vpc_id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "runner_server" {
  template = file("agent.sh")
  vars = {
    repo        = var.repo
    token       = var.token
    runner_name = var.runner_name
  }
}

resource "aws_instance" "bucket_mirror_runner" {
  # TODO: Change by AMI that I've created yesterday
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  subnet_id              = module.vpc.public_subnets[0]
  # TODO: DO we want configure the env variables here instead of the template? I think it makes sense...
  ### https://stackoverflow.com/questions/50668315/set-environment-variables-in-an-aws-instance
  # TODO: Remember to configure this to run also in case of restart
  user_data              = data.template_file.runner_server.rendered
  vpc_security_group_ids = ["sg-052cf424f9878f8f8"]
  key_name               = "management-ipfs-elastic"
}

# TODO: Configure EBS volume

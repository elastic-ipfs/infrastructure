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

data "aws_ami" "bucker_mirror" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.bucket_mirror_ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [local.aws_account_id] # PLNITRO
}

data "template_file" "runner_server" {
  template = file("config-and-start.sh")
  vars = {
    source_bucket_name    = var.source_bucket_name
    s3_client_aws_region  = var.s3_client_aws_region
    s3_prefix             = var.s3_prefix
    s3_suffix             = var.s3_suffix
    sqs_client_aws_region = local.region
    sqs_queue_url         = var.sqs_queue_url
    read_only_mode        = var.read_only_mode
    file_await            = var.file_await
    next_page_await       = var.next_page_await
  }
}

resource "aws_instance" "bucket_mirror_runner" {
  ami                    = data.aws_ami.bucker_mirror.id
  instance_type          = "t2.medium"
  subnet_id              = var.subnet_id
  availability_zone      = data.aws_availability_zones.azs.names[0]
  user_data              = data.template_file.runner_server.rendered
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
    Name = "bucket-mirror"
  }
}

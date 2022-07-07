terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ep-bucket-mirror*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [local.aws_account_id] # PLNITRO
}

# TODO: DO we want configure the env variables here instead of the template? I think it makes sense...
data "template_file" "runner_server" {
  template = file("config-and-start.sh")
  vars = { # TODO: Alguns desses valores dá pra pegar de outputs mesmo!
    source_bucket_name    = var.source_bucket_name
    s3_client_aws_region  = var.s3_client_aws_region
    s3_prefix             = var.s3_prefix
    sqs_client_aws_region = local.region
    sqs_queue_url         = var.sqs_queue_url
    read_only_mode        = var.read_only_mode
    file_await            = var.file_await
    next_page_await       = var.next_page_await
  }
}

resource "aws_instance" "bucket_mirror_runner" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  subnet_id              = var.subnet_id
  user_data              = data.template_file.runner_server.rendered
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = var.ec2_instance_name
  }
}

# TODO: Configure EBS volume
## Is this set by AMI? Does that really makes sense? (Guess it does when we're intending to autoscale?)

packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "amzn2" {
  ami_name      = "peer_e2e_testing"
  instance_type = "t3.micro"
  region        = "us-west-2"
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-kernel-5.10-hvm-2.0.*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["137112412989"]
  }
  ssh_username = "ec2-user"
  tags = {
    Name       = "peer-e2e-testing"
    Team       = "NearForm"
    Project    = "Elastic IPFS"
    Repository = "https://github.com/elastic-ipfs/infrastructure"
    ManagedBy  = "Packer"
  }
}

build {
  sources = [
    "source.amazon-ebs.amzn2"
  ]

  provisioner "shell" { # Install node and create base dir
    inline = [
      "curl -sL https://deb.nodesource.com/setup_${var.node_version}.x | sudo bash -",
      "echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",
      "sudo yum update",
      "sudo yum -y install nodejs git"
    ]
  }
}

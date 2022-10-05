packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "peer_e2e_testing"
  instance_type = "t3.micro"
  region        = "us-west-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
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
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" { # Install node and create base dir
    inline = [
      "curl -sL https://deb.nodesource.com/setup_${var.node_version}.x | sudo bash -",
      "echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",
      "sudo apt-get update",
      "sudo apt-get -y install nodejs git",
      "sudo systemctl status snap.amazon-ssm-agent.amazon-ssm-agent.service"
    ]
  }
}

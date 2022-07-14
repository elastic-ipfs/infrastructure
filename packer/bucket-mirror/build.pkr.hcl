packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "bucket-mirror"
  instance_type = "t2.micro"
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
    Name       = "bucket-mirror"
    Team       = "NearForm"
    Project    = "IPFS-Elastic-Provider"
    Repository = "https://github.com/web3-storage/ipfs-elastic-provider-infrastructure"
    ManagedBy  = "Packer"
  }
}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [ # Install node
      "curl -sL https://deb.nodesource.com/setup_18.x | sudo bash -",
      "sudo apt -y install nodejs"
    ]
  }

  # TODO: Provisioner file copy
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.1"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.0.0"
}

data "http" "cloudflare_certificate_chain" {
  url = "https://developers.cloudflare.com/ssl/static/origin_ca_rsa_root.pem"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "tls_cert_request" "cert_request" {
  private_key_pem = tls_private_key.private_key.private_key_pem
}

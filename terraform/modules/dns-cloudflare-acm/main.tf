terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.0.0"
}

# READ THIS (Important): For now it has a manual step: Updating domain server with the new generated route 53 DNS Servers. 
# If this is not done, certificate validation will fail.
resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subdomains
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

## Add validation cnames to CloudFlare
resource "cloudflare_record" "validation_cname" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      value = dvo.resource_record_value
      type  = dvo.resource_record_type
    }
  }
  zone_id = var.zone_id
  name    = each.value.name
  value   = each.value.value
  type    = each.value.type
}


# ASKs ACM to validate based on fqdns
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in cloudflare_record.validation_cname : record.hostname]

  timeouts {
    create = "45m"
  }
}

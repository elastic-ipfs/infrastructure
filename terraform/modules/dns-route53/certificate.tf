# READ THIS (Important): For now it has a manual step: Updating domain server with the new generated route 53 DNS Servers. 
# If this is not done, certificate validation will fail.
resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = [local.api_domain]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}


# Acho que isso é específico para AWS mas eu consigo pegar o mesmo esquema e jogar no CloudFlare
# Aqui adiciona os resources
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.existing_zone ? data.aws_route53_zone.hosted_zone[0].zone_id : aws_route53_zone.hosted_zone[0].zone_id
}

# Aqui manda validar
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

  timeouts {
    create = "45m"
  }
}

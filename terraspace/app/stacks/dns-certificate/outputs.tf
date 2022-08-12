output "bitswap_peer_record" {
  value = var.bitswap_peer_record
}

output "cf_domain_name" {
  value = var.cf_domain_name
}

output "aws_certificate_arn" {
  value = aws_acm_certificate.cert.arn
  sensitive = true
} 

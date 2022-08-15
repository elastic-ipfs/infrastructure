output "bitswap_peer_record_name" {
  value = var.bitswap_peer_record_name
}

output "cf_domain_name" {
  value = var.cf_domain_name
}

output "aws_certificate_arn" {
  value = aws_acm_certificate.cert.arn
  sensitive = true
} 

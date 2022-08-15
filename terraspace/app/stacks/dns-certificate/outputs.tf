output "bitswap_peer_record_name" {
  value = var.bitswap_peer_record_name
  description = "Bitswap Peer record name"
}

output "cf_domain_name" {
  value = var.cf_domain_name
  description = "DNS Zone name"
}

output "aws_certificate_arn" {
  value = aws_acm_certificate.cert.arn
  sensitive = true
  description = "ACM Certificate"
} 

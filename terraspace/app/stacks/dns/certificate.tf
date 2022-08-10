data "http" "cloudflare_certificate_chain" {
  url = "https://developers.cloudflare.com/ssl/static/origin_ca_rsa_root.pem"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "tls_cert_request" "cert_request" {
  private_key_pem = tls_private_key.private_key.private_key_pem
}

resource "cloudflare_origin_ca_certificate" "cert" {
  csr          = tls_cert_request.cert_request.cert_request_pem
  hostnames    = ["${var.bitswap_peer_record.name}.${var.cf_domain_name}"]
  request_type = "origin-rsa"
}

resource "aws_acm_certificate" "cert" {
  private_key       = tls_private_key.private_key.private_key_pem
  certificate_body  = cloudflare_origin_ca_certificate.cert.certificate
  certificate_chain = data.http.cloudflare_certificate_chain.body
  
  lifecycle {
    create_before_destroy = true
  }
}

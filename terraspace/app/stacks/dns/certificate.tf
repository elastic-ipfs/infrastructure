resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "tls_cert_request" "example" {
  private_key_pem = tls_private_key.private_key.private_key_pem # TODO: Creio que já pego esse direto pra mandar para AWS

#   subject {
#     common_name  = ""
#     organization = "Terraform Test"
#   }
}

resource "cloudflare_origin_ca_certificate" "example" {
  csr                = tls_cert_request.example.cert_request_pem
#   hostnames          = [ "example.com" ]
  hostnames          = [ "${var.bitswap_peer_record.name}.${var.cf_domain_name}" ]
  request_type       = "origin-rsa"
#   requested_validity = 7
}

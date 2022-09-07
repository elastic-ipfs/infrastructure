<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (~> 3.38)

- <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) (~> 3.0)

- <a name="requirement_http"></a> [http](#requirement\_http) (~> 3.0)

- <a name="requirement_tls"></a> [tls](#requirement\_tls) (4.0.1)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (~> 3.38)

- <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) (~> 3.0)

- <a name="provider_http"></a> [http](#provider\_http) (~> 3.0)

- <a name="provider_tls"></a> [tls](#provider\_tls) (4.0.1)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) (resource)
- [cloudflare_origin_ca_certificate.cert](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/origin_ca_certificate) (resource)
- [tls_cert_request.cert_request](https://registry.terraform.io/providers/hashicorp/tls/4.0.1/docs/resources/cert_request) (resource)
- [tls_private_key.private_key](https://registry.terraform.io/providers/hashicorp/tls/4.0.1/docs/resources/private_key) (resource)
- [http_http.cloudflare_certificate_chain](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_bitswap_peer_record_name"></a> [bitswap\_peer\_record\_name](#input\_bitswap\_peer\_record\_name)

Description: Bitswap Peer record name

Type: `string`

### <a name="input_cf_domain_name"></a> [cf\_domain\_name](#input\_cf\_domain\_name)

Description: DNS Zone name

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_aws_certificate_arn"></a> [aws\_certificate\_arn](#output\_aws\_certificate\_arn)

Description: ACM Certificate

### <a name="output_bitswap_peer_record_name"></a> [bitswap\_peer\_record\_name](#output\_bitswap\_peer\_record\_name)

Description: Bitswap Peer record name

### <a name="output_cf_domain_name"></a> [cf\_domain\_name](#output\_cf\_domain\_name)

Description: DNS Zone name
<!-- END_TF_DOCS -->
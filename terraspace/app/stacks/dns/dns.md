<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (~> 3.38)

- <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) (~> 3.0)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (~> 3.38)

- <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) (~> 3.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [aws_route53_record.peer_bitswap_load_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) (resource)
- [aws_route53_record.peer_bitswap_load_balancer_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) (resource)
- [aws_route53_zone.hosted_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) (resource)
- [cloudflare_record.bitswap_peer](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) (resource)
- [aws_route53_zone.hosted_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) (data source)
- [cloudflare_zone.dns](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zone) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_aws_domain_name"></a> [aws\_domain\_name](#input\_aws\_domain\_name)

Description: The name of the hosted zone to either create or lookup

Type: `string`

### <a name="input_bitswap_load_balancer_hosted_zone"></a> [bitswap\_load\_balancer\_hosted\_zone](#input\_bitswap\_load\_balancer\_hosted\_zone)

Description: Bitswap LoadBalancer Hosted Zone. This load balancer is created and managed by Kubernetes

Type: `string`

### <a name="input_bitswap_peer_record_name"></a> [bitswap\_peer\_record\_name](#input\_bitswap\_peer\_record\_name)

Description: Bitswap Peer record name

Type: `string`

### <a name="input_bitswap_peer_record_value"></a> [bitswap\_peer\_record\_value](#input\_bitswap\_peer\_record\_value)

Description: Bitswap Peer record value. This load balancer is created and managed by Kubernetes

Type: `string`

### <a name="input_cf_domain_name"></a> [cf\_domain\_name](#input\_cf\_domain\_name)

Description: DNS Zone name

Type: `string`

### <a name="input_create_zone"></a> [create\_zone](#input\_create\_zone)

Description: If true, creates a managed hosted zone

Type: `bool`

### <a name="input_deprecated_route53_subdomains_bitwsap_loadbalancer"></a> [deprecated\_route53\_subdomains\_bitwsap\_loadbalancer](#input\_deprecated\_route53\_subdomains\_bitwsap\_loadbalancer)

Description: Subdomains that will be handled by peer svc loadbalancer

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_bitswap_loadbalancer_domain"></a> [bitswap\_loadbalancer\_domain](#output\_bitswap\_loadbalancer\_domain)

Description: Domain name for bitswap peer
<!-- END_TF_DOCS -->
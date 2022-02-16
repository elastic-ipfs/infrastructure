# Readme

For now it has a manual step, which is updating domain server with the new generated route 53 DNS Servers. If this is not done, certificate validation will fail.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.38 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.38 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_api_gateway_base_path_mapping.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping) | resource |
| [aws_api_gateway_domain_name.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name) | resource |
| [aws_route53_record.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.peer_bitswap_load_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.provider_load_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.hosted_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [terraform_remote_state.indexing](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.peer](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bitswap_load_balancer_hostname"></a> [bitswap\_load\_balancer\_hostname](#input\_bitswap\_load\_balancer\_hostname) | Bitswap LoadBalancer URL | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | n/a | `string` | `"franciscocardosotest.com"` | no |
| <a name="input_profile"></a> [profile](#input\_profile) | n/a | `string` | n/a | yes |
| <a name="input_provider_load_balancer_hostname"></a> [provider\_load\_balancer\_hostname](#input\_provider\_load\_balancer\_hostname) | Provider LoadBalancer URL | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_subdomain_apis"></a> [subdomain\_apis](#input\_subdomain\_apis) | Name for a API Gateway subdomain | `string` | `"api.uploader"` | no |
| <a name="input_subdomains_bitwsap_loadbalancer"></a> [subdomains\_bitwsap\_loadbalancer](#input\_subdomains\_bitwsap\_loadbalancer) | Subdomains that will be handled by peer svc loadbalancer | `string` | `"peer"` | no |
| <a name="input_subdomains_provider_loadbalancer"></a> [subdomains\_provider\_loadbalancer](#input\_subdomains\_provider\_loadbalancer) | Subdomains that will be handled by provider svc loadbalancer | `string` | `"provider"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
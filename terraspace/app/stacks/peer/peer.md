<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.38 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.38 |
| <a name="provider_http"></a> [http](#provider\_http) | ~> 2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 18.2.0 |
| <a name="module_gateway_endpoint_to_dynamodb"></a> [gateway\_endpoint\_to\_dynamodb](#module\_gateway\_endpoint\_to\_dynamodb) | ../../modules/gateway-endpoint-to-dynamodb | n/a |
| <a name="module_gateway_endpoint_to_s3"></a> [gateway\_endpoint\_to\_s3](#module\_gateway\_endpoint\_to\_s3) | ../../modules/gateway-endpoint-to-s3 | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group_rule.dns_ingress_tcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.dns_ingress_udp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fargate_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.fargate_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [http_http.myip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS account ID | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes version | `string` | `"1.21"` | no |
| <a name="input_region"></a> [region](#input\_region) | VPC Gateways service names are composed using this region | `string` | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | VPC for EKS worker nodes | <pre>object({<br>    name = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | Base64 encoded Certificate Authority PEM for EKS |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | EKS cluster name |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | Used for allowing Kubernetes to manage AWS resources |
| <a name="output_host"></a> [host](#output\_host) | EKS control plane API server endpoint |
<!-- END_TF_DOCS -->
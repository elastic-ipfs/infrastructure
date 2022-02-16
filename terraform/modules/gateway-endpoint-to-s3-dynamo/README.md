<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_vpc_endpoint.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_route_table_association.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_endpoint_route_table_association.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id) | n/a | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_vpc_endpoint_dynamodb"></a> [aws\_vpc\_endpoint\_dynamodb](#output\_aws\_vpc\_endpoint\_dynamodb) | n/a |
| <a name="output_aws_vpc_endpoint_route_table_association_dynamodb"></a> [aws\_vpc\_endpoint\_route\_table\_association\_dynamodb](#output\_aws\_vpc\_endpoint\_route\_table\_association\_dynamodb) | n/a |
| <a name="output_aws_vpc_endpoint_route_table_association_s3"></a> [aws\_vpc\_endpoint\_route\_table\_association\_s3](#output\_aws\_vpc\_endpoint\_route\_table\_association\_s3) | n/a |
| <a name="output_aws_vpc_endpoint_s3"></a> [aws\_vpc\_endpoint\_s3](#output\_aws\_vpc\_endpoint\_s3) | n/a |
<!-- END_TF_DOCS -->
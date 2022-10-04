<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) (resource)
- [aws_vpc_endpoint_route_table_association.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_region"></a> [region](#input\_region)

Description: Region where the resources will be deployed

Type: `string`

### <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id)

Description: n/a

Type: `string`

### <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id)

Description: n/a

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_aws_vpc_endpoint_route_table_association_s3"></a> [aws\_vpc\_endpoint\_route\_table\_association\_s3](#output\_aws\_vpc\_endpoint\_route\_table\_association\_s3)

Description: n/a

### <a name="output_aws_vpc_endpoint_s3"></a> [aws\_vpc\_endpoint\_s3](#output\_aws\_vpc\_endpoint\_s3)

Description: n/a
<!-- END_TF_DOCS -->
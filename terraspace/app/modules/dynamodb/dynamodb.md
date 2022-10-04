<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (~> 3.38)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (~> 3.38)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [aws_dynamodb_table.blocks_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) (resource)
- [aws_dynamodb_table.cars_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) (resource)
- [aws_iam_policy.dynamodb_blocks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_iam_policy.dynamodb_car_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_blocks_table"></a> [blocks\_table](#input\_blocks\_table)

Description: n/a

Type:

```hcl
object({
    name = string
  })
```

### <a name="input_cars_table"></a> [cars\_table](#input\_cars\_table)

Description: n/a

Type:

```hcl
object({
    name = string
  })
```

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_blocks_table"></a> [blocks\_table](#output\_blocks\_table)

Description: Dynamodb blocks table object

### <a name="output_cars_table"></a> [cars\_table](#output\_cars\_table)

Description: Dynamodb cars table object

### <a name="output_dynamodb_blocks_policy"></a> [dynamodb\_blocks\_policy](#output\_dynamodb\_blocks\_policy)

Description: Policy for allowing all Dynamodb Actions for blocks table

### <a name="output_dynamodb_car_policy"></a> [dynamodb\_car\_policy](#output\_dynamodb\_car\_policy)

Description: Policy for allowing all Dynamodb Actions for cars table
<!-- END_TF_DOCS -->
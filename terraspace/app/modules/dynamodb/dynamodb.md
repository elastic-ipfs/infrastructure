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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.blocks_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_dynamodb_table.cars_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_policy.dynamodb_blocks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.dynamodb_car_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_blocks_table"></a> [blocks\_table](#input\_blocks\_table) | n/a | <pre>object({<br>    name = string<br>  })</pre> | n/a | yes |
| <a name="input_cars_table"></a> [cars\_table](#input\_cars\_table) | n/a | <pre>object({<br>    name = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_blocks_table"></a> [blocks\_table](#output\_blocks\_table) | n/a |
| <a name="output_cars_table"></a> [cars\_table](#output\_cars\_table) | n/a |
| <a name="output_dynamodb_blocks_policy"></a> [dynamodb\_blocks\_policy](#output\_dynamodb\_blocks\_policy) | n/a |
| <a name="output_dynamodb_car_policy"></a> [dynamodb\_car\_policy](#output\_dynamodb\_car\_policy) | n/a |
<!-- END_TF_DOCS -->
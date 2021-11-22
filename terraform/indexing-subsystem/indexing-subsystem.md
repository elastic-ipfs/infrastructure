<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.38 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.66.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api-gateway-to-s3"></a> [api-gateway-to-s3](#module\_api-gateway-to-s3) | ../modules/api-gateway-to-s3 | n/a |
| <a name="module_dynamodb"></a> [dynamodb](#module\_dynamodb) | ../modules/dynamodb | n/a |
| <a name="module_lambda-from-s3"></a> [lambda-from-s3](#module\_lambda-from-s3) | ../modules/lambda-from-s3 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.cars](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_carsBucketName"></a> [carsBucketName](#input\_carsBucketName) | Bucket for storing CAR files | `string` | `"cars-test-4"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cars_api_invoke_url"></a> [cars\_api\_invoke\_url](#output\_cars\_api\_invoke\_url) | Use this URL to PUT CAR files |
<!-- END_TF_DOCS -->
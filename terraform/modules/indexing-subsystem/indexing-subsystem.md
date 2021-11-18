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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api-gateway-to-s3"></a> [api-gateway-to-s3](#module\_api-gateway-to-s3) | ../api-gateway-to-s3 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.cars](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_carsBucketName"></a> [carsBucketName](#input\_carsBucketName) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
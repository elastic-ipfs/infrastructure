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
| <a name="module_dynamodb"></a> [dynamodb](#module\_dynamodb) | ../modules/dynamodb | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.s3_cars_policy_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_cars_policy_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_config_peer_bucket_policy_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sqs_multihashes_policy_delete](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sqs_multihashes_policy_receive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sqs_multihashes_policy_send](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_s3_bucket.cars](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.ipfs_peer_bitswap_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_sqs_queue.multihashes_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_carsBucketName"></a> [carsBucketName](#input\_carsBucketName) | Bucket for storing CAR files | `string` | `"ipfs-cars"` | no |
| <a name="input_config_bucket_name"></a> [config\_bucket\_name](#input\_config\_bucket\_name) | n/a | `string` | `"ipfs-peer-bitswap-config"` | no |
| <a name="input_profile"></a> [profile](#input\_profile) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cars_bucket"></a> [cars\_bucket](#output\_cars\_bucket) | n/a |
| <a name="output_dynamodb_blocks_policy"></a> [dynamodb\_blocks\_policy](#output\_dynamodb\_blocks\_policy) | n/a |
| <a name="output_dynamodb_car_policy"></a> [dynamodb\_car\_policy](#output\_dynamodb\_car\_policy) | n/a |
| <a name="output_ipfs_peer_bitswap_config_bucket"></a> [ipfs\_peer\_bitswap\_config\_bucket](#output\_ipfs\_peer\_bitswap\_config\_bucket) | n/a |
| <a name="output_s3_cars_policy_read"></a> [s3\_cars\_policy\_read](#output\_s3\_cars\_policy\_read) | n/a |
| <a name="output_s3_cars_policy_write"></a> [s3\_cars\_policy\_write](#output\_s3\_cars\_policy\_write) | n/a |
| <a name="output_s3_config_peer_bucket_policy_read"></a> [s3\_config\_peer\_bucket\_policy\_read](#output\_s3\_config\_peer\_bucket\_policy\_read) | n/a |
| <a name="output_sqs_multihashes_policy_delete"></a> [sqs\_multihashes\_policy\_delete](#output\_sqs\_multihashes\_policy\_delete) | n/a |
| <a name="output_sqs_multihashes_policy_receive"></a> [sqs\_multihashes\_policy\_receive](#output\_sqs\_multihashes\_policy\_receive) | n/a |
| <a name="output_sqs_multihashes_policy_send"></a> [sqs\_multihashes\_policy\_send](#output\_sqs\_multihashes\_policy\_send) | n/a |
| <a name="output_sqs_multihashes_topic"></a> [sqs\_multihashes\_topic](#output\_sqs\_multihashes\_topic) | n/a |
<!-- END_TF_DOCS -->
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
| <a name="module_dynamodb"></a> [dynamodb](#module\_dynamodb) | ../../modules/dynamodb | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.s3_config_peer_bucket_policy_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_dotstorage_prod_0_policy_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sqs_multihashes_policy_delete](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sqs_multihashes_policy_receive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sqs_multihashes_policy_send](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_s3_bucket.ipfs_peer_bitswap_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.ipfs_peer_bitswap_config_private_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_versioning.ipfs_peer_bitswap_config_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_sqs_queue.multihashes_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.multihashes_topic_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_blocks_table_name"></a> [blocks\_table\_name](#input\_blocks\_table\_name) | Name for blocs dynamodb table. This table is supposed to contain the indexes of blocks | `string` | n/a | yes |
| <a name="input_cars_table_name"></a> [cars\_table\_name](#input\_cars\_table\_name) | Name for cars dynamodb table. This table is supposed to contain references to the CAR file and to control indexing status | `string` | n/a | yes |
| <a name="input_config_bucket_name"></a> [config\_bucket\_name](#input\_config\_bucket\_name) | Name for configuration bucket. This bucket is supposed to contain configurations that some elastic provider apps require | `string` | n/a | yes |
| <a name="input_config_bucket_read_policy_name"></a> [config\_bucket\_read\_policy\_name](#input\_config\_bucket\_read\_policy\_name) | Name for policy which allows reading action for configuration bucket | `string` | n/a | yes |
| <a name="input_dotstorage_bucket_read_policy_name"></a> [dotstorage\_bucket\_read\_policy\_name](#input\_dotstorage\_bucket\_read\_policy\_name) | Name for policy which allows reading messages from existing bucket called 'dotstorage\_prod\_0' | `string` | n/a | yes |
| <a name="input_multihashes_delete_policy_name"></a> [multihashes\_delete\_policy\_name](#input\_multihashes\_delete\_policy\_name) | Name for policy which allows deleting messages from multihashes sqs queue | `string` | n/a | yes |
| <a name="input_multihashes_receive_policy_name"></a> [multihashes\_receive\_policy\_name](#input\_multihashes\_receive\_policy\_name) | Name for policy which allows receiving messages from multihashes sqs queue | `string` | n/a | yes |
| <a name="input_multihashes_send_policy_name"></a> [multihashes\_send\_policy\_name](#input\_multihashes\_send\_policy\_name) | Name for policy which allows sending messages to multihashes sqs queue | `string` | n/a | yes |
| <a name="input_multihashes_topic_name"></a> [multihashes\_topic\_name](#input\_multihashes\_topic\_name) | Name for multihashes sqs queue. This queue is supposed to be read by publisher lambda (content) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_blocks_policy"></a> [dynamodb\_blocks\_policy](#output\_dynamodb\_blocks\_policy) | Policy for allowing all Dynamodb Actions for blocks table |
| <a name="output_dynamodb_car_policy"></a> [dynamodb\_car\_policy](#output\_dynamodb\_car\_policy) | Policy for allowing all Dynamodb Actions for cars table |
| <a name="output_ipfs_peer_bitswap_config_bucket"></a> [ipfs\_peer\_bitswap\_config\_bucket](#output\_ipfs\_peer\_bitswap\_config\_bucket) | The bucket which contains configurations that some elastic provider apps require |
| <a name="output_s3_config_peer_bucket_policy_read"></a> [s3\_config\_peer\_bucket\_policy\_read](#output\_s3\_config\_peer\_bucket\_policy\_read) | Policy for allowing read files from configuration bucket |
| <a name="output_s3_dotstorage_prod_0_policy_read"></a> [s3\_dotstorage\_prod\_0\_policy\_read](#output\_s3\_dotstorage\_prod\_0\_policy\_read) | Policy for allowing reading files from existing bucket called 'dotstorage\_prod\_0' |
| <a name="output_sqs_multihashes_policy_delete"></a> [sqs\_multihashes\_policy\_delete](#output\_sqs\_multihashes\_policy\_delete) | Policy for allowing delete messages from multihashes sqs queue |
| <a name="output_sqs_multihashes_policy_receive"></a> [sqs\_multihashes\_policy\_receive](#output\_sqs\_multihashes\_policy\_receive) | Policy for allowing receive messages from multihashes sqs queue |
| <a name="output_sqs_multihashes_policy_send"></a> [sqs\_multihashes\_policy\_send](#output\_sqs\_multihashes\_policy\_send) | Policy for allowing send messages to multihashes sqs queue |
| <a name="output_sqs_multihashes_topic"></a> [sqs\_multihashes\_topic](#output\_sqs\_multihashes\_topic) | This queue is supposed to be used for triggering publisher lambda (content) |
<!-- END_TF_DOCS -->
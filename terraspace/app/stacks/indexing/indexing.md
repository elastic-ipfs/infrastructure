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
| <a name="module_indexer_lambda_from_sqs"></a> [indexer\_lambda\_from\_sqs](#module\_indexer\_lambda\_from\_sqs) | ../../modules/lambda-from-sqs | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.ecr_repo_indexer_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_iam_policy.sqs_indexer_policy_delete](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sqs_indexer_policy_receive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sqs_indexer_policy_send](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sqs_notifications_policy_delete](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sqs_notifications_policy_receive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sqs_notifications_policy_send](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_sqs_queue.indexer_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.indexer_topic_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.notifications_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS Account ID | `string` | n/a | yes |
| <a name="input_ecr_repository_name"></a> [ecr\_repository\_name](#input\_ecr\_repository\_name) | Name for ECR repo. We use this repo to store indexer lambda docker image | `string` | n/a | yes |
| <a name="input_indexer_lambda"></a> [indexer\_lambda](#input\_indexer\_lambda) | Indexer lambda is the core component of the indexing stack | <pre>object({<br>    name              = string<br>    metrics_namespace = string<br>  })</pre> | n/a | yes |
| <a name="input_indexer_topic_name"></a> [indexer\_topic\_name](#input\_indexer\_topic\_name) | Name for indexer sqs queue. This is queue is supposed to be read by indexer lambda | `string` | n/a | yes |
| <a name="input_node_env"></a> [node\_env](#input\_node\_env) | NODE\_ENV environment variable value for indexer lambda | `string` | n/a | yes |
| <a name="input_notifications_topic_name"></a> [notifications\_topic\_name](#input\_notifications\_topic\_name) | Name for notifications sqs queue. This is queue is supposed to have events created and published by indexer lambda. It can be read by external components | `string` | n/a | yes |
| <a name="input_shared_stack_dynamodb_blocks_policy"></a> [shared\_stack\_dynamodb\_blocks\_policy](#input\_shared\_stack\_dynamodb\_blocks\_policy) | This policy is managed by the shared subsystem. Indexer lambda requires policy for accessing this dynamodb table | <pre>object({<br>    name = string<br>    arn  = string<br>  })</pre> | n/a | yes |
| <a name="input_shared_stack_dynamodb_car_policy"></a> [shared\_stack\_dynamodb\_car\_policy](#input\_shared\_stack\_dynamodb\_car\_policy) | This policy is managed by the shared subsystem. Indexer lambda requires policy for accessing this dynamodb table | <pre>object({<br>    name = string<br>    arn  = string<br>  })</pre> | n/a | yes |
| <a name="input_shared_stack_s3_dotstorage_prod_0_policy_read"></a> [shared\_stack\_s3\_dotstorage\_prod\_0\_policy\_read](#input\_shared\_stack\_s3\_dotstorage\_prod\_0\_policy\_read) | This policy is managed by the shared subsystem. Indexer lambda requires policy for reading external bucket 'dotstorage\_prod\_0' objects content | <pre>object({<br>    name = string<br>    arn  = string<br>  })</pre> | n/a | yes |
| <a name="input_shared_stack_sqs_multihashes_policy_send"></a> [shared\_stack\_sqs\_multihashes\_policy\_send](#input\_shared\_stack\_sqs\_multihashes\_policy\_send) | This policy is managed by the shared subsystem. Indexer lambda requires policy for sending messages to multihashes sqs queue | <pre>object({<br>    name = string<br>    arn  = string<br>  })</pre> | n/a | yes |
| <a name="input_shared_stack_sqs_multihashes_topic"></a> [shared\_stack\_sqs\_multihashes\_topic](#input\_shared\_stack\_sqs\_multihashes\_topic) | This queue is managed by the shared subsystem. Indexer lambda sends messages to it | <pre>object({<br>    url = string<br>    arn = string<br>  })</pre> | n/a | yes |
| <a name="input_sqs_indexer_policy_delete_name"></a> [sqs\_indexer\_policy\_delete\_name](#input\_sqs\_indexer\_policy\_delete\_name) | Name for policy which allows deleting messages from indexer sqs queue | `string` | n/a | yes |
| <a name="input_sqs_indexer_policy_receive_name"></a> [sqs\_indexer\_policy\_receive\_name](#input\_sqs\_indexer\_policy\_receive\_name) | Name for policy which allows receiving messages from indexer sqs queue | `string` | n/a | yes |
| <a name="input_sqs_indexer_policy_send_name"></a> [sqs\_indexer\_policy\_send\_name](#input\_sqs\_indexer\_policy\_send\_name) | Name for policy which allows sending messages to indexer sqs queue | `string` | n/a | yes |
| <a name="input_sqs_notifications_policy_delete_name"></a> [sqs\_notifications\_policy\_delete\_name](#input\_sqs\_notifications\_policy\_delete\_name) | Name for policy which allows deleting messages from notifications sqs queue | `string` | n/a | yes |
| <a name="input_sqs_notifications_policy_receive_name"></a> [sqs\_notifications\_policy\_receive\_name](#input\_sqs\_notifications\_policy\_receive\_name) | Name for policy which allows receiving messages from notifications sqs queue | `string` | n/a | yes |
| <a name="input_sqs_notifications_policy_send_name"></a> [sqs\_notifications\_policy\_send\_name](#input\_sqs\_notifications\_policy\_send\_name) | Name for policy which allows sending messages to notifications sqs queue | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sqs_indexer_policy_send"></a> [sqs\_indexer\_policy\_send](#output\_sqs\_indexer\_policy\_send) | Policy for allowing send messages to indexer sqs queue |
| <a name="output_sqs_indexer_topic"></a> [sqs\_indexer\_topic](#output\_sqs\_indexer\_topic) | This queue is supposed to be used for triggering indexer lambda |
| <a name="output_sqs_notifications_policy_delete"></a> [sqs\_notifications\_policy\_delete](#output\_sqs\_notifications\_policy\_delete) | Policy for allowing delete messages from notifications sqs queue |
| <a name="output_sqs_notifications_policy_receive"></a> [sqs\_notifications\_policy\_receive](#output\_sqs\_notifications\_policy\_receive) | Policy for allowing receive messages from notifications sqs queue |
<!-- END_TF_DOCS -->
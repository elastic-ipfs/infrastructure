<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (~> 3.38)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (~> 3.38)

## Modules

The following Modules are called:

### <a name="module_indexer_lambda_from_sqs"></a> [indexer\_lambda\_from\_sqs](#module\_indexer\_lambda\_from\_sqs)

Source: ../../modules/lambda-from-sqs

Version:

## Resources

The following resources are used by this module:

- [aws_ecr_repository.ecr_repo_indexer_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) (resource)
- [aws_iam_policy.sqs_indexer_policy_receive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_iam_policy.sqs_indexer_policy_send](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_iam_policy.sqs_notifications_policy_delete](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_iam_policy.sqs_notifications_policy_receive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_iam_policy.sqs_notifications_policy_send](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_sqs_queue.indexer_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) (resource)
- [aws_sqs_queue.indexer_topic_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) (resource)
- [aws_sqs_queue.notifications_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_batch_size"></a> [batch\_size](#input\_batch\_size)

Description: Amount of messages indexer lambda should batch to handle simultaneously

Type: `string`

### <a name="input_concurrency"></a> [concurrency](#input\_concurrency)

Description: Amount of blocks indexer lambda should handle simultaneously

Type: `string`

### <a name="input_dynamodb_blocks_table"></a> [dynamodb\_blocks\_table](#input\_dynamodb\_blocks\_table)

Description: DYNAMO\_BLOCKS\_TABLE environment variable value for indexer lambda

Type: `string`

### <a name="input_dynamodb_cars_table"></a> [dynamodb\_cars\_table](#input\_dynamodb\_cars\_table)

Description: DYNAMO\_CARS\_TABLE environment variable value for indexer lambda

Type: `string`

### <a name="input_dynamodb_link_table"></a> [dynamodb\_link\_table](#input\_dynamodb\_link\_table)

Description: DYNAMO\_LINK\_TABLE environment variable value for indexer lambda

Type: `string`

### <a name="input_dynamodb_max_retries"></a> [dynamodb\_max\_retries](#input\_dynamodb\_max\_retries)

Description: DYNAMO\_MAX\_RETRIES environment variable value for indexer lambda

Type: `string`

### <a name="input_dynamodb_retry_delay"></a> [dynamodb\_retry\_delay](#input\_dynamodb\_retry\_delay)

Description: DYNAMO\_RETRY\_DELAY environment variable value for indexer lambda

Type: `string`

### <a name="input_ecr_repository_name"></a> [ecr\_repository\_name](#input\_ecr\_repository\_name)

Description: Name for ECR repo. We use this repo to store indexer lambda docker image

Type: `string`

### <a name="input_indexer_lambda"></a> [indexer\_lambda](#input\_indexer\_lambda)

Description: Indexer lambda is the core component of the indexing stack

Type:

```hcl
object({
    name              = string
    metrics_namespace = string
  })
```

### <a name="input_indexer_topic_name"></a> [indexer\_topic\_name](#input\_indexer\_topic\_name)

Description: Name for indexer sqs queue. This is queue is supposed to be read by indexer lambda

Type: `string`

### <a name="input_node_env"></a> [node\_env](#input\_node\_env)

Description: NODE\_ENV environment variable value for indexer lambda

Type: `string`

### <a name="input_notifications_topic_name"></a> [notifications\_topic\_name](#input\_notifications\_topic\_name)

Description: Name for notifications sqs queue. This is queue is supposed to have events created and published by indexer lambda. It can be read by external components

Type: `string`

### <a name="input_s3_max_retries"></a> [s3\_max\_retries](#input\_s3\_max\_retries)

Description: S3\_MAX\_RETRIES environment variable value for indexer lambda

Type: `string`

### <a name="input_s3_retry_delay"></a> [s3\_retry\_delay](#input\_s3\_retry\_delay)

Description: S3\_RETRY\_DELAY environment variable value for indexer lambda

Type: `string`

### <a name="input_shared_stack_dynamodb_blocks_policy"></a> [shared\_stack\_dynamodb\_blocks\_policy](#input\_shared\_stack\_dynamodb\_blocks\_policy)

Description: This policy is managed by the shared stack. Indexer lambda requires policy for accessing this dynamodb table

Type:

```hcl
object({
    name = string
    arn  = string
  })
```

### <a name="input_shared_stack_dynamodb_car_policy"></a> [shared\_stack\_dynamodb\_car\_policy](#input\_shared\_stack\_dynamodb\_car\_policy)

Description: This policy is managed by the shared stack. Indexer lambda requires policy for accessing this dynamodb table

Type:

```hcl
object({
    name = string
    arn  = string
  })
```

### <a name="input_shared_stack_dynamodb_link_policy"></a> [shared\_stack\_dynamodb\_link\_policy](#input\_shared\_stack\_dynamodb\_link\_policy)

Description: This policy is managed by the shared stack. Indexer lambda requires policy for accessing this dynamodb table

Type:

```hcl
object({
    name = string
    arn  = string
  })
```

### <a name="input_shared_stack_s3_dotstorage_policy_read"></a> [shared\_stack\_s3\_dotstorage\_policy\_read](#input\_shared\_stack\_s3\_dotstorage\_policy\_read)

Description: This policy is managed by the shared stack. Indexer lambda requires policy for reading external bucket 'dotstorage\_prod\_0' objects content

Type:

```hcl
object({
    name = string
    arn  = string
  })
```

### <a name="input_shared_stack_sqs_multihashes_policy_send"></a> [shared\_stack\_sqs\_multihashes\_policy\_send](#input\_shared\_stack\_sqs\_multihashes\_policy\_send)

Description: This policy is managed by the shared stack. Indexer lambda requires policy for sending messages to multihashes sqs queue

Type:

```hcl
object({
    name = string
    arn  = string
  })
```

### <a name="input_shared_stack_sqs_multihashes_topic_url"></a> [shared\_stack\_sqs\_multihashes\_topic\_url](#input\_shared\_stack\_sqs\_multihashes\_topic\_url)

Description: This queue is managed by the shared stack. Indexer lambda sends messages to it

Type: `string`

### <a name="input_sqs_indexer_policy_receive_name"></a> [sqs\_indexer\_policy\_receive\_name](#input\_sqs\_indexer\_policy\_receive\_name)

Description: Name for policy which allows receiving messages from indexer sqs queue

Type: `string`

### <a name="input_sqs_indexer_policy_send_name"></a> [sqs\_indexer\_policy\_send\_name](#input\_sqs\_indexer\_policy\_send\_name)

Description: Name for policy which allows sending messages to indexer sqs queue

Type: `string`

### <a name="input_sqs_notifications_policy_delete_name"></a> [sqs\_notifications\_policy\_delete\_name](#input\_sqs\_notifications\_policy\_delete\_name)

Description: Name for policy which allows deleting messages from notifications sqs queue

Type: `string`

### <a name="input_sqs_notifications_policy_receive_name"></a> [sqs\_notifications\_policy\_receive\_name](#input\_sqs\_notifications\_policy\_receive\_name)

Description: Name for policy which allows receiving messages from notifications sqs queue

Type: `string`

### <a name="input_sqs_notifications_policy_send_name"></a> [sqs\_notifications\_policy\_send\_name](#input\_sqs\_notifications\_policy\_send\_name)

Description: Name for policy which allows sending messages to notifications sqs queue

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_indexing_lambda_image_version"></a> [indexing\_lambda\_image\_version](#input\_indexing\_lambda\_image\_version)

Description: Version tag for publishing lambda

Type: `string`

Default: `"latest"`

## Outputs

The following outputs are exported:

### <a name="output_sqs_indexer_policy_send"></a> [sqs\_indexer\_policy\_send](#output\_sqs\_indexer\_policy\_send)

Description: Policy for allowing send messages to indexer sqs queue

### <a name="output_sqs_indexer_topic"></a> [sqs\_indexer\_topic](#output\_sqs\_indexer\_topic)

Description: This queue is supposed to be used for triggering indexer lambda

### <a name="output_sqs_notifications_policy_delete"></a> [sqs\_notifications\_policy\_delete](#output\_sqs\_notifications\_policy\_delete)

Description: Policy for allowing delete messages from notifications sqs queue

### <a name="output_sqs_notifications_policy_receive"></a> [sqs\_notifications\_policy\_receive](#output\_sqs\_notifications\_policy\_receive)

Description: Policy for allowing receive messages from notifications sqs queue
<!-- END_TF_DOCS -->
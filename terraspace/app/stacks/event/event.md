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

### <a name="module_event_delivery_lambda_from_sqs"></a> [event\_delivery\_lambda\_from\_sqs](#module\_event\_delivery\_lambda\_from\_sqs)

Source: ../../modules/lambda-from-sqs

Version:

## Resources

The following resources are used by this module:

- [aws_ecr_repository.ecr_repo_event_delivery_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) (resource)
- [aws_iam_policy.sns_event_topic_send](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_iam_policy.sqs_event_delivery_queue_receive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_sns_topic.event_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) (resource)
- [aws_sns_topic_subscription.events_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) (resource)
- [aws_sqs_queue.event_delivery_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) (resource)
- [aws_sqs_queue.event_delivery_queue_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) (resource)
- [aws_sqs_queue_policy.event_delivery_queue_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_batch_size"></a> [batch\_size](#input\_batch\_size)

Description: Amount of messages which event delivery lambda should batch to handle simultaneously

Type: `string`

### <a name="input_ecr_repository_name"></a> [ecr\_repository\_name](#input\_ecr\_repository\_name)

Description: Name for ECR repo. We use this repo to store event\_delivery\_lambda docker image

Type: `string`

### <a name="input_event_delivery_lambda"></a> [event\_delivery\_lambda](#input\_event\_delivery\_lambda)

Description: Event delivery lambda is supposed to receive events and send them to external components

Type:

```hcl
object({
    name              = string
    metrics_namespace = string
  })
```

### <a name="input_node_env"></a> [node\_env](#input\_node\_env)

Description: NODE\_ENV environment variable value for event delivery lambda

Type: `string`

### <a name="input_sns_event_topic_name"></a> [sns\_event\_topic\_name](#input\_sns\_event\_topic\_name)

Description: Name for event SNS topic. This topic is supposed to receive events from Elastic IPFS components

Type: `string`

### <a name="input_sns_event_topic_policy_send_name"></a> [sns\_event\_topic\_policy\_send\_name](#input\_sns\_event\_topic\_policy\_send\_name)

Description: Name for policy which allows sending messages to event sns topic

Type: `string`

### <a name="input_sqs_event_delivery_queue_name"></a> [sqs\_event\_delivery\_queue\_name](#input\_sqs\_event\_delivery\_queue\_name)

Description: Name for event delivery SQS queue. This queue is supposed to be used to trigger event-delivery-lambda

Type: `string`

### <a name="input_sqs_event_delivery_queue_policy_receive_name"></a> [sqs\_event\_delivery\_queue\_policy\_receive\_name](#input\_sqs\_event\_delivery\_queue\_policy\_receive\_name)

Description: Name for policy which allows receiving messages from event delivery sqs queue

Type: `string`

### <a name="input_sqs_event_delivery_queue_policy_send_name"></a> [sqs\_event\_delivery\_queue\_policy\_send\_name](#input\_sqs\_event\_delivery\_queue\_policy\_send\_name)

Description: Name for policy which allows sending messages to event delivery sqs queue

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_event_delivery_image_version"></a> [event\_delivery\_image\_version](#input\_event\_delivery\_image\_version)

Description: Version tag for event lambda

Type: `string`

Default: `"latest"`

## Outputs

The following outputs are exported:

### <a name="output_sns_event_topic_policy_send"></a> [sns\_event\_topic\_policy\_send](#output\_sns\_event\_topic\_policy\_send)

Description: Policy for sending messages to SNS event topic
<!-- END_TF_DOCS -->
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

- [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) (resource)
- [aws_cloudwatch_log_metric_filter.lambda_sqs_metrics_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) (resource)
- [aws_iam_policy.lambda_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) (resource)
- [aws_iam_role_policy_attachment.aws_xray_write_only_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) (resource)
- [aws_iam_role_policy_attachment.content_insights](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) (resource)
- [aws_iam_role_policy_attachment.lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) (resource)
- [aws_iam_role_policy_attachment.policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) (resource)
- [aws_lambda_event_source_mapping.event_triggers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) (resource)
- [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_lambda"></a> [lambda](#input\_lambda)

Description: n/a

Type:

```hcl
object({
    name                           = string
    image_uri                      = string
    environment_variables          = map(string)
    memory_size                    = number
    timeout                        = number
    reserved_concurrent_executions = number
    policies_list = list(object({
      name = string,
      arn  = string,
    }))
  })
```

### <a name="input_metrics_namespace"></a> [metrics\_namespace](#input\_metrics\_namespace)

Description: n/a

Type: `string`

### <a name="input_sqs_trigger"></a> [sqs\_trigger](#input\_sqs\_trigger)

Description: n/a

Type:

```hcl
object({
    arn                                = string
    batch_size                         = number
    maximum_batching_window_in_seconds = number
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_custom_metrics"></a> [custom\_metrics](#input\_custom\_metrics)

Description: n/a

Type: `list(string)`

Default: `[]`

### <a name="input_sqs_trigger_function_response_types"></a> [sqs\_trigger\_function\_response\_types](#input\_sqs\_trigger\_function\_response\_types)

Description: n/a

Type: `list(string)`

Default: `null`

## Outputs

No outputs.
<!-- END_TF_DOCS -->
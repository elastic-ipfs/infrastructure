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

- [aws_cloudwatch_log_group.lambda_function_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) (resource)
- [aws_cloudwatch_log_metric_filter.lambda_s3_metrics_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) (resource)
- [aws_iam_policy.lambda_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_iam_role.lambda_function_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) (resource)
- [aws_iam_role_policy_attachment.aws_xray_write_only_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) (resource)
- [aws_iam_role_policy_attachment.lambda_function_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) (resource)
- [aws_iam_role_policy_attachment.lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) (resource)
- [aws_iam_role_policy_attachment.policies_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) (resource)
- [aws_lambda_function.lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) (resource)
- [aws_lambda_permission.with_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) (resource)
- [aws_sns_topic_subscription.topic_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) (resource)
- [aws_sns_topic.source_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sns_topic) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_lambda"></a> [lambda](#input\_lambda)

Description: n/a

Type:

```hcl
object({
    name                  = string
    image_uri             = string
    environment_variables = map(string)
    memory_size           = number
    timeout               = number
    policies_list = list(object({
      name = string,
      arn  = string,
    }))
  })
```

### <a name="input_region"></a> [region](#input\_region)

Description: n/a

Type: `string`

### <a name="input_sns_topic"></a> [sns\_topic](#input\_sns\_topic)

Description: Name of SNS topic which lambda should subscribe to

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_custom_metrics"></a> [custom\_metrics](#input\_custom\_metrics)

Description: n/a

Type: `list(string)`

Default: `[]`

## Outputs

The following outputs are exported:

### <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name)

Description: n/a
<!-- END_TF_DOCS -->
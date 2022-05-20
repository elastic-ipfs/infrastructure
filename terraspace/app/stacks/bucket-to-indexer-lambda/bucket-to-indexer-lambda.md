<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (~> 3.38)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (~> 3.38)

- <a name="provider_terraform"></a> [terraform](#provider\_terraform)

## Modules

The following Modules are called:

### <a name="module_lambda_from_s3"></a> [lambda\_from\_s3](#module\_lambda\_from\_s3)

Source: ../../modules/lambda-from-s3

Version:

## Resources

The following resources are used by this module:

- [aws_ecr_repository.ecr_repo_bucket_to_indexer_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) (resource)
- [terraform_remote_state.indexing](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_bucket"></a> [bucket](#input\_bucket)

Description: PUT events in this bucket trigger lambda

Type:

```hcl
object({
    bucket = string
    arn    = string
    id     = string
  })
```

### <a name="input_indexing_stack_region"></a> [indexing\_stack\_region](#input\_indexing\_stack\_region)

Description: Region which indexer is deployed to

Type: `string`

### <a name="input_lambda"></a> [lambda](#input\_lambda)

Description: bucket\_to\_indexer lambda attributes

Type:

```hcl
object({
    name        = string
    memory_size = string
    timeout     = string
  })
```

### <a name="input_node_env"></a> [node\_env](#input\_node\_env)

Description: NODE\_ENV environment variable value for bucket\_to\_indexer lambda

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_bucket_to_indexer_lambda_image_version"></a> [bucket\_to\_indexer\_lambda\_image\_version](#input\_bucket\_to\_indexer\_lambda\_image\_version)

Description: Version tag for bucket\_to\_indexer lambda

Type: `string`

Default: `"latest"`

## Outputs

No outputs.
<!-- END_TF_DOCS -->
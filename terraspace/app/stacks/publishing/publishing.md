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

### <a name="module_ads_lambda_from_sqs"></a> [ads\_lambda\_from\_sqs](#module\_ads\_lambda\_from\_sqs)

Source: ../../modules/lambda-from-sqs

Version:

### <a name="module_content_lambda_from_sqs"></a> [content\_lambda\_from\_sqs](#module\_content\_lambda\_from\_sqs)

Source: ../../modules/lambda-from-sqs

Version:

## Resources

The following resources are used by this module:

- [aws_ecr_repository.ecr_repo_publisher_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) (resource)
- [aws_iam_policy.s3_ads_policy_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_iam_policy.s3_ads_policy_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_iam_policy.sqs_ads_policy_delete](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_iam_policy.sqs_ads_policy_receive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_iam_policy.sqs_ads_policy_send](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_s3_bucket.ipfs_peer_ads](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) (resource)
- [aws_s3_bucket_acl.ipfs_peer_ads_public_readl_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) (resource)
- [aws_s3_bucket_policy.allow_public_access_to_files](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) (resource)
- [aws_sqs_queue.ads_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) (resource)
- [aws_sqs_queue.ads_topic_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) (resource)
- [aws_iam_policy_document.s3_advertisment_files_public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_ads_lambda"></a> [ads\_lambda](#input\_ads\_lambda)

Description: Publishing (advertisement) lambda namming

Type:

```hcl
object({
    name              = string
    metrics_namespace = string
  })
```

### <a name="input_ads_topic_name"></a> [ads\_topic\_name](#input\_ads\_topic\_name)

Description: Name for advertisment sqs queue. This queue is supposed to have events created and pulished by content and received by publishing

Type: `string`

### <a name="input_content_lambda"></a> [content\_lambda](#input\_content\_lambda)

Description: Publishing (content) lambda namming

Type:

```hcl
object({
    name              = string
    metrics_namespace = string
  })
```

### <a name="input_dns_stack_bitswap_loadbalancer_domain"></a> [dns\_stack\_bitswap\_loadbalancer\_domain](#input\_dns\_stack\_bitswap\_loadbalancer\_domain)

Description: Bitswap peer DNS. This is used for composing the multiaddress value for the BITSWAP\_PEER\_MULTIADDR environment variable. This value is notified to storetheindex

Type: `string`

### <a name="input_ecr_repository_name"></a> [ecr\_repository\_name](#input\_ecr\_repository\_name)

Description: Name for ECR repo. We use this repo to store publishing lambda docker image

Type: `string`

### <a name="input_indexer_node_url"></a> [indexer\_node\_url](#input\_indexer\_node\_url)

Description: storetheindex HTTP API URL

Type: `string`

### <a name="input_node_env"></a> [node\_env](#input\_node\_env)

Description: NODE\_ENV environment variable value for publishing lambdas

Type: `string`

### <a name="input_provider_ads_bucket_name"></a> [provider\_ads\_bucket\_name](#input\_provider\_ads\_bucket\_name)

Description: Bucket for storing advertisement files

Type: `string`

### <a name="input_shared_stack_ipfs_peer_bitswap_config_bucket_id"></a> [shared\_stack\_ipfs\_peer\_bitswap\_config\_bucket\_id](#input\_shared\_stack\_ipfs\_peer\_bitswap\_config\_bucket\_id)

Description: This bucket is managed by the shared subsystem. The bucket which contains configurations that publisher lambdas require

Type: `string`

### <a name="input_shared_stack_s3_config_peer_bucket_policy_read"></a> [shared\_stack\_s3\_config\_peer\_bucket\_policy\_read](#input\_shared\_stack\_s3\_config\_peer\_bucket\_policy\_read)

Description: This policy is managed by the shared subsystem. Publishing lambdas need to read peer configuration from S3 bucket

Type:

```hcl
object({
    name = string
    arn  = string
  })
```

### <a name="input_shared_stack_sqs_multihashes_policy_delete"></a> [shared\_stack\_sqs\_multihashes\_policy\_delete](#input\_shared\_stack\_sqs\_multihashes\_policy\_delete)

Description: This policy is managed by the shared subsystem. Publishing lambda (content) requires policy for deleting messages from multihashes sqs queue

Type:

```hcl
object({
    name = string
    arn  = string
  })
```

### <a name="input_shared_stack_sqs_multihashes_policy_receive"></a> [shared\_stack\_sqs\_multihashes\_policy\_receive](#input\_shared\_stack\_sqs\_multihashes\_policy\_receive)

Description: This policy is managed by the shared subsystem. Publishing lambda (content) requires policy for receiving messages from multihashes sqs queue

Type:

```hcl
object({
    name = string
    arn  = string
  })
```

### <a name="input_shared_stack_sqs_multihashes_topic_arn"></a> [shared\_stack\_sqs\_multihashes\_topic\_arn](#input\_shared\_stack\_sqs\_multihashes\_topic\_arn)

Description: This queue is managed by the shared subsystem. Publisher lambda (content) receives messages from this queue

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_publishing_lambda_image_version"></a> [publishing\_lambda\_image\_version](#input\_publishing\_lambda\_image\_version)

Description: Version tag for publishing lambda

Type: `string`

Default: `"latest"`

## Outputs

No outputs.
<!-- END_TF_DOCS -->
<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (~> 3.38)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (~> 3.38)

- <a name="provider_template"></a> [template](#provider\_template)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [aws_iam_instance_profile.ec2_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) (resource)
- [aws_iam_role.ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) (resource)
- [aws_iam_role_policy_attachment.policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) (resource)
- [aws_instance.bucket_mirror_runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) (resource)
- [aws_ami.bucker_mirror](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) (data source)
- [aws_availability_zones.azs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) (data source)
- [template_file.runner_server](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_bucket_mirror_ami_name"></a> [bucket\_mirror\_ami\_name](#input\_bucket\_mirror\_ami\_name)

Description: Name of image (AMI) which contains 'bucket-mirror' prepared to run

Type: `string`

### <a name="input_ec2_instance_name"></a> [ec2\_instance\_name](#input\_ec2\_instance\_name)

Description: Name for the EC2 which will run bucket mirror

Type: `string`

### <a name="input_key_name"></a> [key\_name](#input\_key\_name)

Description: AWS key Pair name

Type: `string`

### <a name="input_policies_list"></a> [policies\_list](#input\_policies\_list)

Description: List of policies which are going to be attached to EC2 role

Type:

```hcl
list(object({
    name = string,
    arn  = string,
  }))
```

### <a name="input_s3_client_aws_region"></a> [s3\_client\_aws\_region](#input\_s3\_client\_aws\_region)

Description: Which region is the source bucket

Type: `string`

### <a name="input_s3_suffix"></a> [s3\_suffix](#input\_s3\_suffix)

Description: Only read objects with this suffix

Type: `string`

### <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id)

Description: ID of security group where bucket-mirror should run

Type: `string`

### <a name="input_source_bucket_name"></a> [source\_bucket\_name](#input\_source\_bucket\_name)

Description: Name of bucket to read objects from

Type: `string`

### <a name="input_sqs_client_aws_region"></a> [sqs\_client\_aws\_region](#input\_sqs\_client\_aws\_region)

Description: Which region is the indexer SQS queue

Type: `string`

### <a name="input_sqs_queue_url"></a> [sqs\_queue\_url](#input\_sqs\_queue\_url)

Description: indexer SQS queue URL

Type: `string`

### <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id)

Description: ID of subnet where bucket-mirror should run

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_file_await"></a> [file\_await](#input\_file\_await)

Description: How long to await between files. Useful for avoiding DB throttling

Type: `number`

Default: `0`

### <a name="input_next_page_await"></a> [next\_page\_await](#input\_next\_page\_await)

Description: How long to await after fetching 1000 files. Useful for avoiding DB throttling

Type: `number`

Default: `0`

### <a name="input_read_only_mode"></a> [read\_only\_mode](#input\_read\_only\_mode)

Description: Should be 'disable' for sending messages to SQS queue. Otherwise it will just read existing files from bucket

Type: `string`

Default: `"enabled"`

### <a name="input_s3_prefix"></a> [s3\_prefix](#input\_s3\_prefix)

Description: Only read objects with this prefix

Type: `string`

Default: `""`

## Outputs

No outputs.
<!-- END_TF_DOCS -->
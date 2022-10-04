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
- [aws_iam_role.ec2_role_atc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) (resource)
- [aws_iam_role_policy_attachment.policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) (resource)
- [aws_instance.peer_e2e_testing_runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) (resource)
- [aws_ami.peer_e2e_testing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) (data source)
- [aws_availability_zones.azs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_peer_e2e_testing_ami_name"></a> [peer_e2e_testing\_ami\_name](#input\_peer_e2e_testing\_ami\_name)

Description: Name of image (AMI) which contains 'peer-e2e-testing' prepared to run

Type: `string`

### <a name="input_ec2_instance_name"></a> [ec2\_instance\_name](#input\_ec2\_instance\_name)

Description: Name for the EC2 which will run peer-e2e-testing

Type: `string`

### <a name="input_key_name"></a> [key\_name](#input\_key\_name)

Description: AWS key Pair name

Type: `string`

### <a name="input_log_after_value_files"></a> [log\_after\_value\_files](#input\_log\_after\_value\_files)

Description: define after how many files to update run status in log

Type: `number`

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

Description: ID of security group where peer-e2e-testing should run

Type: `string`


### <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id)

Description: ID of subnet where peer-e2e-testing should run

Type: `string`

## Outputs

No outputs.
<!-- END_TF_DOCS -->
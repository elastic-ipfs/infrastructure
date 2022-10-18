<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_helm"></a> [helm](#requirement\_helm) (~> 2.4.1)

- <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) (~> 2.7.1)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws)

- <a name="provider_helm"></a> [helm](#provider\_helm) (~> 2.4.1)

- <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) (~> 2.7.1)

## Modules

The following Modules are called:

### <a name="module_iam_assumable_role_cluster_autoscaler"></a> [iam\_assumable\_role\_cluster\_autoscaler](#module\_iam\_assumable\_role\_cluster\_autoscaler)

Source: terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc

Version: ~> 4.0

## Resources

The following resources are used by this module:

- [aws_iam_policy.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [helm_release.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [kubernetes_service_account.irsa-autoscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_cluster_autoscaler_policy_name"></a> [cluster\_autoscaler\_policy\_name](#input\_cluster\_autoscaler\_policy\_name)

Description: Name for policy which allows cluster autoscaler operator to handle AWS node group

Type: `string`

### <a name="input_cluster_autoscaler_role_name"></a> [cluster\_autoscaler\_role\_name](#input\_cluster\_autoscaler\_role\_name)

Description: Name for cluster autoscaler role

Type: `string`

### <a name="input_cluster_autoscaler_version"></a> [cluster\_autoscaler\_version](#input\_cluster\_autoscaler\_version)

Description: Version for cluster autoscaler operator

Type: `string`

### <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name)

Description: n/a

Type: `string`

### <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url)

Description: Used for allowing Kubernetes to manage AWS resources

Type: `string`

### <a name="input_region"></a> [region](#input\_region)

Description: Region where the resources will be deployed

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_namespace"></a> [namespace](#input\_namespace)

Description: n/a

Type: `string`

Default: `"kube-system"`

### <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name)

Description: n/a

Type: `string`

Default: `"cluster-autoscaler"`

## Outputs

No outputs.
<!-- END_TF_DOCS -->
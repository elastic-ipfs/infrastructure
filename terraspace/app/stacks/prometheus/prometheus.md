<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (~> 4.12)

- <a name="requirement_helm"></a> [helm](#requirement\_helm) (~> 2.4.1)

- <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) (~> 2.7.1)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (~> 4.12)

- <a name="provider_helm"></a> [helm](#provider\_helm) (~> 2.4.1)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [aws_iam_policy.write_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) (resource)
- [aws_iam_policy_attachment.prometheus_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) (resource)
- [aws_iam_role.iamproxy_ingest_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) (resource)
- [aws_prometheus_workspace.ipfs_elastic_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/prometheus_workspace) (resource)
- [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#input\_cluster\_ca\_certificate)

Description: This certificate is managed by the peer stack. Base64 encoded Certificate Authority PEM for EKS

Type: `string`

### <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id)

Description: This ID is managed by the peer stack. The same as EKS cluster name

Type: `string`

### <a name="input_eks_oidc_provider_arn"></a> [eks\_oidc\_provider\_arn](#input\_eks\_oidc\_provider\_arn)

Description: The ARN of the OIDC Provider if enable\_irsa = true

Type: `string`

### <a name="input_host"></a> [host](#input\_host)

Description: This URL is managed by the peer stack. EKS control plane API server endpoint

Type: `string`

### <a name="input_oidc_provider"></a> [oidc\_provider](#input\_oidc\_provider)

Description: The OpenID Connect identity provider (issuer URL without leading https://)

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_namespace"></a> [namespace](#input\_namespace)

Description: Prometheus kubernetes namespace

Type: `string`

Default: `"prometheus"`

### <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name)

Description: Prometheus service account name

Type: `string`

Default: `"iamproxy-ingest-service-account"`

## Outputs

The following outputs are exported:

### <a name="output_prometheus_endpoint"></a> [prometheus\_endpoint](#output\_prometheus\_endpoint)

Description: Prometheus endpoint
<!-- END_TF_DOCS -->
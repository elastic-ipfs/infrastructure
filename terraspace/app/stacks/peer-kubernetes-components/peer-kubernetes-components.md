<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_helm"></a> [helm](#requirement\_helm) (~> 2.4.1)

- <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) (~> 2.7.1)

## Providers

The following providers are used by this module:

- <a name="provider_helm"></a> [helm](#provider\_helm) (~> 2.4.1)

- <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) (~> 2.7.1)

## Modules

The following Modules are called:

### <a name="module_cluster_autoscaler"></a> [cluster\_autoscaler](#module\_cluster\_autoscaler)

Source: ../../modules/cluster-autoscaler

Version:

### <a name="module_eks_auth_sync"></a> [eks\_auth\_sync](#module\_eks\_auth\_sync)

Source: ../../modules/eks-auth-sync

Version:

### <a name="module_iam_assumable_role_admin"></a> [iam\_assumable\_role\_admin](#module\_iam\_assumable\_role\_admin)

Source: terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc

Version: ~> 4.0

## Resources

The following resources are used by this module:

- [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [helm_release.metric_server](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [kubernetes_service_account.irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#input\_cluster\_ca\_certificate)

Description: This certificate is managed by the peer stack. Base64 encoded Certificate Authority PEM for EKS

Type: `string`

### <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id)

Description: This ID is managed by the peer stack. The same as EKS cluster name

Type: `string`

### <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url)

Description: This URL is managed by the peer stack. Used for allowing Kubernetes to manage AWS resources

Type: `string`

### <a name="input_host"></a> [host](#input\_host)

Description: This URL is managed by the peer stack. EKS control plane API server endpoint

Type: `string`

### <a name="input_region"></a> [region](#input\_region)

Description: Resources that manage AWS resources require the region

Type: `string`

### <a name="input_service_account_roles"></a> [service\_account\_roles](#input\_service\_account\_roles)

Description: Manages Kubernetes serviceaccounts (sa) that should assume roles. Also manages the roles themselves and their polices associations. Those irsa services can later be associated with kubernetes deployments

Type:

```hcl
map(object({
    service_account_name      = string,
    service_account_namespace = string,
    role_name                 = string
    policies_list = list(object({
      name = string,
      arn  = string,
    }))
  }))
```

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_iam_roles"></a> [iam\_roles](#output\_iam\_roles)

Description: All roles managed by this stack
<!-- END_TF_DOCS -->
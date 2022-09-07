<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (~> 4.12)

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

- [helm_release.argocd_apps](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [helm_release.metric_server](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [kubernetes_namespace.bitswap_peer_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) (resource)
- [kubernetes_namespace.logging_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) (resource)
- [kubernetes_service_account.irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_aws_certificate_arn"></a> [aws\_certificate\_arn](#input\_aws\_certificate\_arn)

Description: ACM Certificate which is hooked with Load Balancer SSL port

Type: `string`

### <a name="input_bitswap_peer_deployment_branch"></a> [bitswap\_peer\_deployment\_branch](#input\_bitswap\_peer\_deployment\_branch)

Description: Branch which argocd should be looking at for syncing bitswap peer

Type: `string`

### <a name="input_bitswap_peer_namespace"></a> [bitswap\_peer\_namespace](#input\_bitswap\_peer\_namespace)

Description: Namespace where bitswap peer will be deployed to

Type: `string`

### <a name="input_cluster_autoscaler_policy_name"></a> [cluster\_autoscaler\_policy\_name](#input\_cluster\_autoscaler\_policy\_name)

Description: Name for policy which allows cluster autoscaler operator to handle AWS node group

Type: `string`

### <a name="input_cluster_autoscaler_role_name"></a> [cluster\_autoscaler\_role\_name](#input\_cluster\_autoscaler\_role\_name)

Description: Name for cluster autoscaler role

Type: `string`

### <a name="input_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#input\_cluster\_ca\_certificate)

Description: This certificate is managed by the peer stack. Base64 encoded Certificate Authority PEM for EKS

Type: `string`

### <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id)

Description: This ID is managed by the peer stack. The same as EKS cluster name

Type: `string`

### <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url)

Description: This URL is managed by the peer stack. Used for allowing Kubernetes to manage AWS resources

Type: `string`

### <a name="input_eks_auth_sync_policy_name"></a> [eks\_auth\_sync\_policy\_name](#input\_eks\_auth\_sync\_policy\_name)

Description: Name for policy which allows eks auth sync to read tags from IAM

Type: `string`

### <a name="input_eks_auth_sync_role_name"></a> [eks\_auth\_sync\_role\_name](#input\_eks\_auth\_sync\_role\_name)

Description: Name for EKS auth sync role

Type: `string`

### <a name="input_host"></a> [host](#input\_host)

Description: This URL is managed by the peer stack. EKS control plane API server endpoint

Type: `string`

### <a name="input_logging_namespace"></a> [logging\_namespace](#input\_logging\_namespace)

Description: Namespace where fluentd will be deployed to

Type: `string`

### <a name="input_region"></a> [region](#input\_region)

Description: Resources that manage AWS resources require the region

Type: `string`

### <a name="input_service_account_roles"></a> [service\_account\_roles](#input\_service\_account\_roles)

Description: Manages Kubernetes serviceaccounts (sa) that should assume roles. Also manages the roles themselves and their polices associations. Those irsa services can later be associated with kubernetes deployments

Type:

```hcl
map(object({
    service_account_name = string,
    role_name            = string
    policies_list = list(object({
      name = string,
      arn  = string,
    }))
  }))
```

## Optional Inputs

No optional inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
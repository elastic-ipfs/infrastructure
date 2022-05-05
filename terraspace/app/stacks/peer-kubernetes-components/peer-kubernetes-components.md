<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.7.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.4.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.7.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster_autoscaler"></a> [cluster\_autoscaler](#module\_cluster\_autoscaler) | ../../modules/cluster-autoscaler | n/a |
| <a name="module_eks_auth_sync"></a> [eks\_auth\_sync](#module\_eks\_auth\_sync) | ../../modules/eks-auth-sync | n/a |
| <a name="module_iam_assumable_role_admin"></a> [iam\_assumable\_role\_admin](#module\_iam\_assumable\_role\_admin) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.metric_server](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_service_account.irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#input\_cluster\_ca\_certificate) | This certificate is managed by the peer stack. Base64 encoded Certificate Authority PEM for EKS | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | This ID is managed by the peer stack. The same as EKS cluster name | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | This URL is managed by the peer stack. Used for allowing Kubernetes to manage AWS resources | `string` | n/a | yes |
| <a name="input_deploy_argocd"></a> [deploy\_argocd](#input\_deploy\_argocd) | Whether to deploy or not the argocd to the cluster | `bool` | `true` | no |
| <a name="input_deploy_cluster_autoscaler"></a> [deploy\_cluster\_autoscaler](#input\_deploy\_cluster\_autoscaler) | Whether to deploy or not the cluster\_autoscaler to the cluster | `bool` | `true` | no |
| <a name="input_deploy_eks_auth_sync"></a> [deploy\_eks\_auth\_sync](#input\_deploy\_eks\_auth\_sync) | Whether to deploy or not the eks\_auth\_sync daemon to the cluster | `bool` | `true` | no |
| <a name="input_host"></a> [host](#input\_host) | This URL is managed by the peer stack. EKS control plane API server endpoint | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Resources that manage AWS resources require the region | `string` | n/a | yes |
| <a name="input_service_account_roles"></a> [service\_account\_roles](#input\_service\_account\_roles) | Manages Kubernetes serviceaccounts (sa) that should assume roles. Also manages the roles themselves and their polices associations. Those irsa services can later be associated with kubernetes deployments | <pre>map(object({<br>    service_account_name      = string,<br>    service_account_namespace = string,<br>    role_name                 = string<br>    policies_list = list(object({<br>      name = string,<br>      arn  = string,<br>    }))<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_roles"></a> [iam\_roles](#output\_iam\_roles) | All roles managed by this stack |
<!-- END_TF_DOCS -->
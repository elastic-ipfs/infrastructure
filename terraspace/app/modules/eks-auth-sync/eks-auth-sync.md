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
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.7.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_oidc_eks_auth_sync"></a> [iam\_oidc\_eks\_auth\_sync](#module\_iam\_oidc\_eks\_auth\_sync) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.eks_auth_sync_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [kubernetes_config_map.eksauth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_cron_job.eksauth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cron_job) | resource |
| [kubernetes_role.eksauth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role) | resource |
| [kubernetes_role.eksauth-system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role) | resource |
| [kubernetes_role_binding.eksauth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.eksauth-system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_service_account.eksauth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Will be used for configuring IAM scanner | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | n/a | `string` | n/a | yes |
| <a name="input_cronjob_schedule"></a> [cronjob\_schedule](#input\_cronjob\_schedule) | n/a | `string` | `"*/15 * * * *"` | no |
| <a name="input_deploy_cluster_autoscaler"></a> [deploy\_cluster\_autoscaler](#input\_deploy\_cluster\_autoscaler) | Whether to deploy or not the cluster autoscaler daemon on the cluster | `bool` | `true` | no |
| <a name="input_eks_auth_sync_policy_name"></a> [eks\_auth\_sync\_policy\_name](#input\_eks\_auth\_sync\_policy\_name) | n/a | `string` | `"eks-auth-sync-policy"` | no |
| <a name="input_eks_auth_sync_role_name"></a> [eks\_auth\_sync\_role\_name](#input\_eks\_auth\_sync\_role\_name) | n/a | `string` | `"eks-auth-sync-role"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Which namespace to deploy eks-auth-sync | `string` | `"kube-system"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the resources will be deployed | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
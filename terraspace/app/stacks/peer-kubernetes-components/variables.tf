variable "cluster_id" {
  type = string
  description = "This ID is managed by the peer stack. The same as EKS cluster name"
}

variable "cluster_oidc_issuer_url" {
  type = string
  description = "This URL is managed by the peer stack. Used for allowing Kubernetes to manage AWS resources"
}

variable "region" {
  type = string
  description = "Resources that manage AWS resources require the region"
}

variable "config_bucket_name" {
  type = string
  description = "This bucket is managed by the shared stack. Peer container reads its objects content"

}

variable "host" {
  type = string
  description = "This URL is managed by the peer stack. EKS control plane API server endpoint"
}

variable "cluster_ca_certificate" {
  type = string
  description = "This certificate is managed by the peer stack. Base64 encoded Certificate Authority PEM for EKS"
}

variable "service_account_roles" {
  type = map(object({
    service_account_name      = string,
    service_account_namespace = string,
    role_name                 = string
    policies_list = list(object({
      name = string,
      arn  = string,
    }))
  }))
  description = "Manages Kubernetes serviceaccounts (sa) that should assume roles. Also manages the roles themselves and their polices associations. Those irsa services can later be associated with kubernetes deployments"

}

variable "eks_auth_sync_policy_name" {
  type    = string
  default = "eks-auth-sync-policy"
  description = "Name of policy that enables reading of user/role tags"
}

variable "eks_auth_sync_role_name" {
  type    = string
  default = "eks-auth-sync-role"
  description = "Name of role with permissions for reading of user/role tags"
}

variable "deploy_eks_auth_sync" {
  description = "Whether to deploy or not the eks_auth_sync daemon to the cluster"
  type        = bool
  default     = true
}

variable "deploy_argocd" {
  description = "Whether to deploy or not the argocd to the cluster"
  type        = bool
  default     = true
}

variable "deploy_cluster_autoscaler" {
  description = "Whether to deploy or not the cluster_autoscaler to the cluster"
  type        = bool
  default     = true
}

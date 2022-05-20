variable "cluster_id" {
  type        = string
  description = "This ID is managed by the peer stack. The same as EKS cluster name"
}

variable "cluster_oidc_issuer_url" {
  type        = string
  description = "This URL is managed by the peer stack. Used for allowing Kubernetes to manage AWS resources"
}

variable "region" {
  type        = string
  description = "Resources that manage AWS resources require the region"
}

variable "host" {
  type        = string
  description = "This URL is managed by the peer stack. EKS control plane API server endpoint"
}

variable "cluster_ca_certificate" {
  type        = string
  description = "This certificate is managed by the peer stack. Base64 encoded Certificate Authority PEM for EKS"
}

variable "service_account_roles" {
  type = map(object({
    service_account_name = string,
    role_name            = string
    policies_list = list(object({
      name = string,
      arn  = string,
    }))
  }))
  description = "Manages Kubernetes serviceaccounts (sa) that should assume roles. Also manages the roles themselves and their polices associations. Those irsa services can later be associated with kubernetes deployments"
}

variable "bitswap_peer_namespace" {
  type        = string
  description = "Namespace where bitswap peer will be deployed to"
}

variable "bitswap_peer_deployment_branch" {
  type        = string
  description = "Branch which argocd should be looking at for syncing bitswap peer"
}

variable "eks_auth_sync_role_name" {
  type        = string
  description = "Name for EKS auth sync role"
}

variable "eks_auth_sync_policy_name" {
  type        = string
  description = "Name for policy which allows eks auth sync to read tags from IAM"
}

variable "cluster_autoscaler_role_name" {
  type        = string
  description = "Name for cluster autoscaler role"
}

variable "cluster_autoscaler_policy_name" {
  type        = string
  description = "Name for policy which allows cluster autoscaler operator to handle AWS node group"
}



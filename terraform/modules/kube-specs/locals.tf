locals {
  service_account_namespace = "default"
  service_account_name      = "irsa"

  config_context = "eks_${var.eks_cluster_name}"
}
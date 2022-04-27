output "eks_token" {
  value = data.aws_eks_cluster_auth.eks.token
  sensitive = true
}
output "eks_host" {
  value = data.aws_eks_cluster.eks.endpoint
  sensitive = true
}

output "eks_cluster_ca_certificate" {
  value = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  sensitive = true
}

output "fargate_iam_role" {
  value = module.eks.fargate_profiles["default"].iam_role_name
}

output "managed_node_group_iam_role" {
  value = module.eks.eks_managed_node_groups["test-ipfs-peer-subsys"].iam_role_name
}

output "kube_config_file_name" {
  value = module.eks.kubeconfig_filename
}

output "host" {
  value = module.kube-base-components.host
}

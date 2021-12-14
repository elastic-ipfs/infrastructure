output "kube_config_file_name" {
  value = module.eks.kubeconfig_filename
}

output "load_balancer_hostname" {
  value = module.kube-specs.load_balancer_hostname
}

output "host" {
  value = module.kube-specs.host
}

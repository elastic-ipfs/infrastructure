output "kube_config_file_name" {
  value = module.eks.kubeconfig_filename
}

output "bitswap_load_balancer_hostname" {
  value = module.kube-specs.bitswap_load_balancer_hostname
}

output "provider_load_balancer_hostname" {
  value = module.kube-specs.provider_load_balancer_hostname
}

output "host" {
  value = module.kube-specs.host
}

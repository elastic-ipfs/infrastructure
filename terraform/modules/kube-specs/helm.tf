provider "helm" {
  kubernetes {
    config_path    = var.kubeconfig_output_path
    config_context = local.config_context
  }
}

module "eks-metrics-server" {
  source  = "lablabs/eks-metrics-server/aws"
  version = "0.7.1"
}

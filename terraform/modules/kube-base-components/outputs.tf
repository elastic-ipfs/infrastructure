output "host" {
  value = var.host
}

output "iam_roles" {
  value = {
    for iam_role_arn, attributes in module.iam_assumable_role_admin :
    iam_role_arn => attributes.iam_role_arn
  }
}

output "prometheus_endpoint" {
  value = module.prometheus.prometheus_endpoint
}

output "grafana_endpoint" {
  value = module.prometheus.grafana_endpoint
}


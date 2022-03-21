output "prometheus_endpoint" {
  value = aws_prometheus_workspace.ipfs_elastic_provider.prometheus_endpoint
}

output "grafana_endpoint" {
  value = aws_grafana_workspace.ipfs_elastic_provider.endpoint
}

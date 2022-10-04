output "prometheus_endpoint" {
  value       = aws_prometheus_workspace.ipfs_elastic_provider.prometheus_endpoint 
  description = "Prometheus endpoint"
}
provider "helm" {
  kubernetes {
    host                   = var.host
    token                  = var.token
    cluster_ca_certificate = var.cluster_ca_certificate
  }
}

resource "helm_release" "cloudwatch_exporter" {
  name             = "cloudwatch-exporter"
  chart            = "prometheus-cloudwatch-exporter"
  version          = "~> 0.18.0"
  repository       = "https://prometheus-community.github.io/helm-charts"
  namespace        = local.cloudwatch_exporter.namespace
  create_namespace = true

  set {
    name  = "service.portName"
    value = "http-metrics"
  }

  set {
    name  = "service.labels.metricsMonitor"
    value = "true"
    type = "string"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = local.cloudwatch_exporter.serviceaccount.name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.cloudwatch_exporter_role.iam_role_arn
    type = "string"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/sts-regional-endpoints"
    value = "true"
    type = "string"
  }

  set {
    name  = "config"
    value = <<EOF
      region: us-west-2
      metrics:
      - aws_dimensions:
        - FunctionName
        - Resource
        aws_metric_name: Invocations
        aws_namespace: AWS/Lambda
        aws_statistics:
        - Sum
      - aws_dimensions:
        - FunctionName
        - Resource
        aws_metric_name: Errors
        aws_namespace: AWS/Lambda
        aws_statistics:
        - Sum
      - aws_dimensions:
        - FunctionName
        - Resource
        aws_metric_name: Duration
        aws_namespace: AWS/Lambda
        aws_statistics:
        - Average
      - aws_dimensions:
        - FunctionName
        - Resource
        aws_metric_name: Duration
        aws_namespace: AWS/Lambda
        aws_statistics:
        - Maximum
      - aws_dimensions:
        - FunctionName
        - Resource
        aws_metric_name: Duration
        aws_namespace: AWS/Lambda
        aws_statistics:
        - Minimum
      - aws_dimensions:
        - FunctionName
        - Resource
        aws_metric_name: Throttles
        aws_namespace: AWS/Lambda
        aws_statistics:
        - Sum
      - aws_dimensions:
        - FunctionName
        - Resource
        aws_metric_name: ConcurrentExecutions
        aws_namespace: AWS/Lambda
        aws_statistics:
        - Sum
      - aws_dimensions:
        - FunctionName
        - Resource
        aws_metric_name: UnreservedConcurrentExecutions
        aws_namespace: AWS/Lambda
        aws_statistics:
        - Sum
      - aws_dimensions:
        - function_name
        aws_namespace: LambdaInsights
        aws_metric_name: total_network
        aws_statistics:
        - Sum
      - aws_dimensions:
        - function_name
        aws_namespace: LambdaInsights 
        aws_metric_name: memory_utilization
        aws_statistics:
        - Maximum
    EOF
  }
}

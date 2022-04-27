provider "helm" {
  kubernetes {
    host                   = var.host
    token                  = var.token
    cluster_ca_certificate = var.cluster_ca_certificate
  }
}

resource "helm_release" "cloudwatch_exporter" {
  name             = "cloudwatch-exporter"
  count            = var.deploy_cloudwatch_exporter ? 1 : 0
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
    type  = "string"
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
    type  = "string"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/sts-regional-endpoints"
    value = "true"
    type  = "string"
  }

  set {
    name  = "config"
    value = <<EOF
      region: us-west-2
      metrics:
      # DynamoDB
      - aws_dimensions: 
        - Operation
        - TableName
        aws_metric_name: SuccessfulRequestLatency
        aws_namespace: AWS/DynamoDB
        aws_statistics:
        - Average          
      - aws_dimensions: 
        - Operation
        - TableName
        aws_metric_name: ThrottledRequests
        aws_namespace: AWS/DynamoDB
        aws_statistics:
        - Sum
      - aws_dimensions: 
        - TableName
        aws_metric_name: ConsumedReadCapacityUnits
        aws_namespace: AWS/DynamoDB
        aws_statistics:
        - Sum
      - aws_dimensions: 
        - TableName
        aws_metric_name: ProvisionedReadCapacityUnits
        aws_namespace: AWS/DynamoDB
        aws_statistics:
        - Average
      - aws_dimensions: 
        - TableName
        aws_metric_name: ConsumedWriteCapacityUnits
        aws_namespace: AWS/DynamoDB
        aws_statistics:
        - Sum
      - aws_dimensions: 
        - TableName
        aws_metric_name: ProvisionedWriteCapacityUnits
        aws_namespace: AWS/DynamoDB
        aws_statistics:
        - Average
      - aws_dimensions: 
        - TableName
        - Operation
        aws_metric_name: ReturnedItemCount
        aws_namespace: AWS/DynamoDB
        aws_statistics:
        - Sum
      # SQS
      - aws_dimensions: 
        - QueueName
        aws_metric_name: NumberOfMessagesSent
        aws_namespace: AWS/SQS
        aws_statistics:
        - Average
      - aws_dimensions: 
        - QueueName
        aws_metric_name: NumberOfMessagesReceived
        aws_namespace: AWS/SQS
        aws_statistics:
        - Average
      - aws_dimensions: 
        - QueueName
        aws_metric_name: NumberOfMessagesDeleted
        aws_namespace: AWS/SQS
        aws_statistics:
        - Average
      - aws_dimensions: 
        - QueueName
        aws_metric_name: ApproximateAgeOfOldestMessage
        aws_namespace: AWS/SQS
        aws_statistics:
        - Average
      - aws_dimensions: 
        - QueueName
        aws_metric_name: ApproximateNumberOfMessagesVisible
        aws_namespace: AWS/SQS
        aws_statistics:
        - Average      
      - aws_dimensions: 
        - QueueName
        aws_metric_name: ApproximateNumberOfMessagesDelayed
        aws_namespace: AWS/SQS
        aws_statistics:
        - Average      
      - aws_dimensions: 
        - QueueName
        aws_metric_name: NumberOfEmptyReceives
        aws_namespace: AWS/SQS
        aws_statistics:
        - Average
      - aws_dimensions: 
        - QueueName
        aws_metric_name: SentMessageSize
        aws_namespace: AWS/SQS
        aws_statistics:
        - Average
      # S3
      - aws_dimensions: 
        - BucketName
        - StorageType
        aws_metric_name: NumberOfObjects
        aws_namespace: AWS/S3
        aws_statistics:
        - Average
      - aws_dimensions: 
        - BucketName
        - StorageType
        aws_metric_name: BucketSizeBytes
        aws_namespace: AWS/S3
        aws_statistics:
        - Average
      # Lambda Insights
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
        - Average
      - aws_dimensions:
        - FunctionName
        - Resource
        aws_metric_name: UnreservedConcurrentExecutions
        aws_namespace: AWS/Lambda
        aws_statistics:
        - Sum
        - Average
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
      # Custom Lambda metrics
      - aws_dimensions: 
        - ipfs_provider_component
        aws_metric_name: s3-heads-count
        aws_namespace: uploader-lambda-metrics
        aws_statistics:
        - Sum
        - Average    
      - aws_dimensions: 
        - ipfs_provider_component
        aws_metric_name: s3-signs-count
        aws_namespace: uploader-lambda-metrics
        aws_statistics:
        - Sum
        - Average 
      - aws_dimensions: 
        - ipfs_provider_component
        aws_metric_name: dynamo-creates-count
        aws_namespace: indexer-lambda-metrics
        aws_statistics:
        - Sum
        - Average 
      - aws_dimensions: 
        - ipfs_provider_component
        aws_metric_name: dynamo-deletes-count
        aws_namespace: indexer-lambda-metrics
        aws_statistics:
        - Sum
        - Average 
      - aws_dimensions: 
        - ipfs_provider_component
        aws_metric_name: dynamo-reads-count
        aws_namespace: indexer-lambda-metrics
        aws_statistics:
        - Sum
        - Average
      - aws_dimensions: 
        - ipfs_provider_component
        aws_metric_name: dynamo-updates-count
        aws_namespace: indexer-lambda-metrics
        aws_statistics:
        - Sum
        - Average
      - aws_dimensions: 
        - ipfs_provider_component
        aws_metric_name: s3-fetchs-count
        aws_namespace: indexer-lambda-metrics
        aws_statistics:
        - Sum
        - Average
      - aws_dimensions: 
        - ipfs_provider_component
        aws_metric_name: sqs-publishes-count
        aws_namespace: indexer-lambda-metrics
        aws_statistics:
        - Sum
        - Average
      - aws_dimensions: 
        - ipfs_provider_component
        aws_metric_name: s3-fetchs-count
        aws_namespace: publishing-lambda-metrics
        aws_statistics:
        - Sum
        - Average
      - aws_dimensions: 
        - ipfs_provider_component
        aws_metric_name: s3-uploads-count
        aws_namespace: publishing-lambda-metrics
        aws_statistics:
        - Sum
        - Average
      - aws_dimensions: 
        - ipfs_provider_component
        aws_metric_name: sqs-publishes-count
        aws_namespace: publishing-lambda-metrics
        aws_statistics:
        - Sum
        - Average
      - aws_dimensions: 
        - ipfs_provider_component
        aws_metric_name: http-head-cid-fetchs-count
        aws_namespace: publishing-lambda-metrics
        aws_statistics:
        - Sum
        - Average
      - aws_dimensions: 
        - ipfs_provider_component
        aws_metric_name: http-indexer-announcements-count
        aws_namespace: publishing-lambda-metrics
        aws_statistics:
        - Sum
        - Average
      EOF
  }
}

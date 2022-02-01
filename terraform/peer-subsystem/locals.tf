locals {
  node_security_group_additional_rules = {
    metrics_server_8443_ing = {
      description                   = "Cluster API to node metrics server"
      protocol                      = "tcp"
      from_port                     = 8443
      to_port                       = 8443
      type                          = "ingress"
      source_cluster_security_group = true
    }
    metrics_server_10250_ing = {
      description = "Node to node kubelets (Required for metrics server)"
      protocol    = "tcp"
      from_port   = 10250
      to_port     = 10250
      type        = "ingress"
      self        = true
    }
    metrics_server_10250_eg = {
      description = "Node to node metrics server"
      protocol    = "tcp"
      from_port   = 10250
      to_port     = 10250
      type        = "egress"
      self        = true
    }
    prometheus_coredns_9153_ing = {
      description = "Node to node Prometheus scrape CoreDNS metrics"
      protocol    = "tcp"
      from_port   = 9153
      to_port     = 9153
      type        = "ingress"
      self        = true
    }
    prometheus_coredns_9153_eg = {
      description = "Node to node Prometheus scrape CoreDNS metrics"
      protocol    = "tcp"
      from_port   = 9153
      to_port     = 9153
      type        = "egress"
      self        = true
    }
    prometheus_grafana_3000_ing = {
      description = "Node to node Prometheus scrape Grafana metrics"
      protocol    = "tcp"
      from_port   = 3000
      to_port     = 3000
      type        = "ingress"
      self        = true
    }
    prometheus_grafana_3000_eg = {
      description = "Node to node Prometheus scrape Grafana metrics"
      protocol    = "tcp"
      from_port   = 3000
      to_port     = 3000
      type        = "egress"
      self        = true
    }
    prometheus_grafana_9090_ing = {
      description = "Node to node Grafana Datasource Prometheus"
      protocol    = "tcp"
      from_port   = 9090
      to_port     = 9090
      type        = "ingress"
      self        = true
    }
    prometheus_grafana_9090_eg = {
      description = "Node to node Grafana Datasource Prometheus"
      protocol    = "tcp"
      from_port   = 9090
      to_port     = 9090
      type        = "egress"
      self        = true
    }
    prometheus_kubeproxy_10249_ing = {
      description = "Node to node prometheus scrape kube proxy metrics"
      protocol    = "tcp"
      from_port   = 10249
      to_port     = 10249
      type        = "ingress"
      self        = true
    }
    prometheus_kubeproxy_10249_eg = {
      description = "Node to node prometheus scrape kube proxy metrics"
      protocol    = "tcp"
      from_port   = 10249
      to_port     = 10249
      type        = "egress"
      self        = true
    }
    prometheus_nodeexporter_9100_ing = {
      description = "Node to node prometheus scrape node exporter metrics"
      protocol    = "tcp"
      from_port   = 9100
      to_port     = 9100
      type        = "ingress"
      self        = true
    }
    prometheus_nodeexporter_9100_eg = {
      description = "Node to node prometheus scrape node exporter metrics"
      protocol    = "tcp"
      from_port   = 9100
      to_port     = 9100
      type        = "egress"
      self        = true
    }

    prometheus_kubestatemetrics_8080_ing = {
      description = "Node to node prometheus scrape kube state metrics"
      protocol    = "tcp"
      from_port   = 8080
      to_port     = 8080
      type        = "ingress"
      self        = true
    }
    prometheus_kubestatemetrics_8080_eg = {
      description = "Node to node prometheus scrape kube state metrics"
      protocol    = "tcp"
      from_port   = 8080
      to_port     = 8080
      type        = "egress"
      self        = true
    }

    prometheus_alertmanager_9093_ing = {
      description = "Node to node prometheus alertmanager"
      protocol    = "tcp"
      from_port   = 9093
      to_port     = 9093
      type        = "ingress"
      self        = true
    }
    prometheus_alertmanager_9093_eg = {
      description = "Node to node prometheus alertmanager"
      protocol    = "tcp"
      from_port   = 9093
      to_port     = 9093
      type        = "egress"
      self        = true
    }

    prometheus_alertmanager_9094_ing = {
      description = "Node to node prometheus alertmanager"
      protocol    = "tcp"
      from_port   = 9094
      to_port     = 9094
      type        = "ingress"
      self        = true
    }
    prometheus_alertmanager_9094_eg = {
      description = "Node to node prometheus alertmanager"
      protocol    = "tcp"
      from_port   = 9094
      to_port     = 9094
      type        = "egress"
      self        = true
    }


    prometheus_alertmanager_9094__udp_ing = {
      description = "Node to node prometheus alertmanager"
      protocol    = "udp"
      from_port   = 9094
      to_port     = 9094
      type        = "ingress"
      self        = true
    }
    prometheus_alertmanager_9094_udp_eg = {
      description = "Node to node prometheus alertmanager"
      protocol    = "udp"
      from_port   = 9094
      to_port     = 9094
      type        = "egress"
      self        = true
    }
  }
}

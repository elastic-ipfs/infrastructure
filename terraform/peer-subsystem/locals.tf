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

    aws_lb_controller_webhook_9443_ing = {
      description                   = "Webhook from AWS LB Controller: Cluster API to node"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
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

    metrics_server_10255_ing = {
      description = "Node to node metrics server"
      protocol    = "tcp"
      from_port   = 10255
      to_port     = 10255
      type        = "ingress"
      self        = true
    }
    metrics_server_10255_eg = {
      description = "Node to node metrics server"
      protocol    = "tcp"
      from_port   = 10255
      to_port     = 10255
      type        = "egress"
      self        = true
    }

    metrics_server_4194_ing = {
      description = "Node to node metrics server (CAdvisor)"
      protocol    = "tcp"
      from_port   = 4194
      to_port     = 4194
      type        = "ingress"
      self        = true
    }
    metrics_server_4194_eg = {
      description = "Node to node metrics server (CAdvisor)"
      protocol    = "tcp"
      from_port   = 4194
      to_port     = 4194
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


    prometheus_bitswap_peer_3001_ing = {
      description = "Node to node Prometheus scrape bitswap_peer metrics"
      protocol    = "tcp"
      from_port   = 3001
      to_port     = 3001
      type        = "ingress"
      self        = true
    }
    prometheus_bitswap_peer_3001_eg = {
      description = "Node to node Prometheus scrape bitswap_peer metrics"
      protocol    = "tcp"
      from_port   = 3001
      to_port     = 3001
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

    node_to_node_443_ing = {
      description = "Node to node HTTPS"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      self        = true
    }

    node_to_node_443_out = {
      description = "Node to node HTTPS"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "egress"
      self        = true
    }

    node_to_node_80_ing = {
      description = "Node to node HTTP"
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      type        = "ingress"
      self        = true
    }

    node_to_node_80_out = {
      description = "Node to node HTTP"
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      type        = "egress"
      self        = true
    }

    argocd_repo_server_8081_ing = {
      description = "Node to node argocd-repo-server"
      protocol    = "tcp"
      from_port   = 8081
      to_port     = 8081
      type        = "ingress"
      self        = true
    }
    argocd_repo_server_8081_eg = {
      description = "Node to node argocd-repo-server"
      protocol    = "tcp"
      from_port   = 8081
      to_port     = 8081
      type        = "egress"
      self        = true
    }

    argocd-application-controller_8082_ing = {
      description = "Node to node argocd-application-controller"
      protocol    = "tcp"
      from_port   = 8082
      to_port     = 8082
      type        = "ingress"
      self        = true
    }
    argocd-application-controller_8082_eg = {
      description = "Node to node argocd-application-controller"
      protocol    = "tcp"
      from_port   = 8082
      to_port     = 8082
      type        = "egress"
      self        = true
    }


    argocd_redis_6379_ing = {
      description = "Node to node argocd-redis"
      protocol    = "tcp"
      from_port   = 6379
      to_port     = 6379
      type        = "ingress"
      self        = true
    }
    argocd_redis_6379_eg = {
      description = "Node to node argocd-redis"
      protocol    = "tcp"
      from_port   = 6379
      to_port     = 6379
      type        = "egress"
      self        = true
    }

    traceroute_33434_33464_eg = {
      description = "Enable troubleshoot: UDP Traceroute to all internet"
      protocol    = "UDP"
      from_port   = 33434
      to_port     = 33655
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }

    traceroute_ICMP_eg = {
      description = "Enable troubleshoot: ICMP Traceroute to all internet"
      protocol    = "ICMP"
      from_port   = -1
      to_port     = -1
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

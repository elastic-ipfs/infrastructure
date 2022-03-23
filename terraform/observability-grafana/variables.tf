variable "region" {
  type = string
}

variable "grafana_endpoint" {
  type = string
  default = ""
}

variable "prometheus_endpoint" {
  type = string
  default = ""
}

variable "grafana_dashboards_ids" {
  type = list(string)
  default = []
}

variable "grafana_auth" {
  type = string
}

variable "region" {
  type = string
}

variable "grafana_url" {
  type = string
}

variable "grafana_auth" {
  type = string
}

variable "grafana_dashboards_ids" {
  type = list(string)
}

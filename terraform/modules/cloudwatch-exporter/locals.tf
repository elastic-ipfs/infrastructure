locals {
  cloudwatch_exporter = {
    namespace = "cloudwatch-exporter"
    serviceaccount = {
      name = "cloudwatch-exporter"
    }
  }
}

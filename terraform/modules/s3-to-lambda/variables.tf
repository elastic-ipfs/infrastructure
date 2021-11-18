variable "bucket" {
  # List each field in `azurerm_route_table` that your module will access
  type = object({
    bucket = string
    arn    = string
    id     = string
  })
}

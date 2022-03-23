locals {
  uploader_lambda = {
    name = "uploader"
  }

  percentiles = [
    "1",
    "10",
    "25",
    "50",
    "75",
    "90",
    "99",
  ]
}

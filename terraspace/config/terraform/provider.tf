provider "aws" {
  profile = var.profile
  region  = var.region
  default_tags {
    tags = {
      Team        = "NearForm"
      Project     = "IPFS-Elastic-Provider"
      Repository  = "https://github.com/web3-storage/ipfs-elastic-provider-infrastructure"
      Environment = "<%= Terraspace.env %>"
      # Stack   = "DNS" ## TODO: How to replace it with stack name?
      ManagedBy = "Terraform"
    }
  }
}

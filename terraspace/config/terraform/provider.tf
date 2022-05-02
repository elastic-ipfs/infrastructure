provider "aws" {
  default_tags {
    tags = {
      Team        = "NearForm"
      Project     = "IPFS-Elastic-Provider"
      Repository  = "https://github.com/web3-storage/ipfs-elastic-provider-infrastructure"
      Environment = "<%= expansion(':ENV') %>"
      Stack       = "<%= expansion(':MOD_NAME') %>"
      ManagedBy   = "Terraform"
    }
  }
}

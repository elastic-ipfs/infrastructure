provider "aws" {
  default_tags {
    tags = {
      Team        = "NearForm"
      Project     = "Elastic IPFS"
      Repository  = "https://github.com/elastic-ipfs/infrastructure"
      Environment = "<%= expansion(':ENV') %>"
      Stack       = "<%= expansion(':MOD_NAME') %>"
      ManagedBy   = "Terraform"
    }
  }
}

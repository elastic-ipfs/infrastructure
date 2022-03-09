# Docs: https://www.terraform.io/docs/providers/aws/index.html
#
# If AWS_PROFILE and AWS_REGION is set, then the provider is optional.  Here's an example anyway:
#
# provider "aws" {
#   region = "us-east-1"
# }

provider "aws" {
  default_tags {
    tags = {
      automation = "Terraspace"
      repo = "ipfs-elastic-provider-infrastructure"
      project = "infra-prj-a"
      owner = "nearform"
      env = "<%= Terraspace.env %>"
    }
  }
}


//AWS_PROFILE=protocol-labs-prod AWS_REGION=us-west-2 TS_ENV=dev bundle exec terraspace plan network-base
//AWS_PROFILE=protocol-labs-prod AWS_REGION=us-west-2 TS_ENV=dev bundle exec terraspace plan server
//AWS_PROFILE=protocol-labs-prod AWS_REGION=us-west-2 TS_ENV=dev bundle exec terraspace all plan
//
//AWS_PROFILE=protocol-labs-prod AWS_REGION=us-west-2 TS_ENV=dev bundle exec terraspace up network-base
//AWS_PROFILE=protocol-labs-prod AWS_REGION=us-west-2 TS_ENV=dev bundle exec terraspace up server
//AWS_PROFILE=protocol-labs-prod AWS_REGION=us-west-2 TS_ENV=dev bundle exec terraspace all up
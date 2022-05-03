vpc = {
  name = "<%= expansion(':ENV') %>-ep-peer"
}
cluster_version          = 1.21
cluster_name             = "<%= expansion(':ENV') %>-ep-peer"
provider_ads_bucket_name = "<%= expansion(':ENV') %>-ep-ipfs-provider-ads" # TODO: Get from publishing stack output
account_id               = "<%= expansion(':ACCOUNT') %>"

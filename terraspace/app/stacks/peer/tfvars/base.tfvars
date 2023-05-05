cluster_name = "<%= expansion(':ENV') %>-ep-peer"
account_id   = "<%= expansion(':ACCOUNT') %>"
region       = "<%= expansion(':REGION') %>"
eks = {
  name = "<%= expansion(':ENV') %>-ep-peer"
  version = 1.23
  eks_managed_node_groups = {
    name           = "<%= expansion(':ENV') %>-ep-peer"
    desired_size   = 2
    min_size       = 2
    max_size       = 5
    instance_types = ["c6g.2xlarge"]
  }
}
config_table = {
  name     = "<%= expansion(':ENV') %>-ep-bitswap-config"
  hash_key = "key"
}

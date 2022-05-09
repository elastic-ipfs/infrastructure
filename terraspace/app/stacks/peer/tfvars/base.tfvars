cluster_name = "<%= expansion(':ENV') %>-ep-peer"
account_id   = "<%= expansion(':ACCOUNT') %>"
region       = "<%= expansion(':REGION') %>"
eks = {
  name = "<%= expansion(':ENV') %>-ep-peer"
  version = 1.21
  eks_managed_node_groups = {
    version        = 1.21
    desired_size   = 2
    min_size       = 2
    max_size       = 5
    instance_types = ["t2.medium"]
  }
}

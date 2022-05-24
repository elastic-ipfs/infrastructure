vpc = {
  name                 = "test-ipfs-peer-subsys"
  cidr                 = "10.0.0.0/16"
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
  public_subnets       = ["10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}
eks = {
  name    = "test-ipfs-peer-subsys"
  version = 1.21
  eks_managed_node_groups = {
    name           = "test-ipfs-peer-subsys"
    desired_size   = 2
    min_size       = 2
    max_size       = 20
    instance_types = ["c6i.2xlarge"]
  }
}
account_id = "<%= expansion(':ACCOUNT') %>"
# enable_http_egress_sg_rules  = true
# enable_tracerouting_sg_rules = true

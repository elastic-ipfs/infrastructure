vpc = {
  name                 = "test-ipfs-peer-subsys"
  cidr                 = "10.0.0.0/16"
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
  public_subnets       = ["10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}
cluster_name    = "test-ipfs-peer-subsys"
account_id      = "<%= expansion(':ACCOUNT') %>"

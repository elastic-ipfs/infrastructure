vpc = {
  name                 = "<%= expansion(':ENV') %>-ep-peer-subsys"
  cidr                 = "10.2.0.0/16"
  private_subnets      = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24", "10.2.4.0/24"]
  public_subnets       = ["10.2.5.0/24", "10.2.6.0/24", "10.2.7.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_dns_hostnames = true
}

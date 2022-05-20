vpc = {
  name                 = "<%= expansion(':ENV') %>-ep-peer-subsys"
  cidr                 = "10.1.0.0/16"
  private_subnets      = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
  public_subnets       = ["10.1.5.0/24", "10.1.6.0/24", "10.1.7.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

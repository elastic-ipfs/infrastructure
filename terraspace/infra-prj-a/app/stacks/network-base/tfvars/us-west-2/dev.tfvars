cidr_block = "10.0.4.0/22"
private_subnets = {
  a = {
    name = "nw-a"
    az = "us-west-2a"
    cidr = "10.0.4.0/27"
  },
  b = {
    name = "nw-b"
    az = "us-west-2b"
    cidr = "10.0.4.32/27"
  },
  c = {
    name = "nw-c"
    az = "us-west-2c"
    cidr = "10.0.4.64/27"
  },
}

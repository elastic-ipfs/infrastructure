cidr_block = "10.0.0.0/22"
private_subnets = {
  a = {
    name = "nw-a"
    az = "us-east-1a"
    cidr = "10.0.0.0/27"
  },
  b = {
    name = "nw-b"
    az = "us-east-1b"
    cidr = "10.0.0.32/27"
  },
  c = {
    name = "nw-c"
    az = "us-east-1c"
    cidr = "10.0.0.64/27"
  },
}

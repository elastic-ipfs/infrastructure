resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = merge(
    var.vpc_tags,
    {
      Name = var.vpc_name
    }
  )
}

resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  cidr_block        = each.value.cidr
  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.az
  tags              = { Name = each.value.name }
}



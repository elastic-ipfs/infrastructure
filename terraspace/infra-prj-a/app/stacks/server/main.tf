resource "aws_alb" "this" {
  subnets            = var.subnet_ids
  load_balancer_type = "application"
  internal           = true
}

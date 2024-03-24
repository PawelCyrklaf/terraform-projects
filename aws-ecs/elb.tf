resource "aws_lb" "ecs_lb" {
  name               = var.elb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_security_group.id]
  subnets            = toset(module.vpc.public_subnets)

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = var.elb_target_group_name
  port        = var.app_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id
  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "listenerHTTP" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
  depends_on = [aws_lb.ecs_lb]
}

#resource "aws_lb_listener" "listenerHTTPS" {
#  load_balancer_arn = aws_lb.ecs_lb.arn
#  port              = "443"
#  protocol          = "HTTPS"
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.ecs_tg.arn
#  }
#  depends_on = [aws_lb.ecs_lb]
#}
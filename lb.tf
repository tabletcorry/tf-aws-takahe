resource "aws_lb" "self" {
  name               = "${local.module_tags.module}-${var.name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = module.vpc.public_subnets

  drop_invalid_header_fields = true

  ip_address_type = "dualstack"
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.self.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.lb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_web.arn
  }

  depends_on = [aws_acm_certificate_validation.lb]
}

resource "aws_lb_target_group" "ecs_web" {
  name        = "${local.module_tags.module}-${var.name}-ecs-web"
  port        = local.web_listen_port
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  deregistration_delay = "15"

  lifecycle {
    create_before_destroy = true
  }
}
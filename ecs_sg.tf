resource "aws_security_group" "ecs_web" {
  name   = "${local.module_tags.module}-${var.name}-ecs-web"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ecs_web_egress" {
  security_group_id = aws_security_group.ecs_web.id
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "ecs_web_ingress_lb" {
  security_group_id        = aws_security_group.ecs_web.id
  type                     = "ingress"
  to_port                  = local.web_listen_port
  protocol                 = "tcp"
  from_port                = local.web_listen_port
  source_security_group_id = aws_security_group.lb.id
}

resource "aws_security_group" "ecs_stator" {
  name   = "${local.module_tags.module}-${var.name}-ecs-stator"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ecs_stator_egress" {
  security_group_id = aws_security_group.ecs_stator.id
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}
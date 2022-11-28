resource "aws_security_group" "lb" {
  name        = "${local.module_tags.module}-${var.name}-alb"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "lb_egress" {
  security_group_id = aws_security_group.lb.id
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "lb_ingress" {
  security_group_id = aws_security_group.lb.id
  type              = "ingress"
  to_port           = 443
  protocol          = "tcp"
  from_port         = 443
  cidr_blocks       = ["99.7.60.76/32"]
  ipv6_cidr_blocks  = ["2600:1700:4a30:1e5f::/64"]
}
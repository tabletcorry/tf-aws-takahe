resource "aws_security_group" "ecs_primary_web" {
  name        = "ecs_primary_web"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ecs_primary_web_egress" {
  security_group_id = aws_security_group.ecs_primary_web.id
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "ecs_primary_web_ingress" {
  security_group_id        = aws_security_group.ecs_primary_web.id
  type                     = "ingress"
  to_port                  = "8000"
  protocol                 = "tcp"
  from_port                = "8000"
  source_security_group_id = aws_security_group.lb.id
}

resource "aws_security_group" "ecs_primary_stator" {
  name        = "ecs_primary_stator"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ecs_primary_stator_egress" {
  security_group_id = aws_security_group.ecs_primary_stator.id
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}
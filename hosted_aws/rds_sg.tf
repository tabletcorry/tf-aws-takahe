resource "aws_security_group" "rds" {
  name   = "${local.module_tags.module}-${var.name}-rds"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "rds_egress" {
  security_group_id = aws_security_group.rds.id
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "rds_ingress_ecs_web" {
  security_group_id        = aws_security_group.rds.id
  type                     = "ingress"
  to_port                  = 5432
  protocol                 = "tcp"
  from_port                = 5432
  source_security_group_id = aws_security_group.ecs_web.id
}

resource "aws_security_group_rule" "rds_ingress_ecs_stator" {
  security_group_id        = aws_security_group.rds.id
  type                     = "ingress"
  to_port                  = 5432
  protocol                 = "tcp"
  from_port                = 5432
  source_security_group_id = aws_security_group.ecs_stator.id
}
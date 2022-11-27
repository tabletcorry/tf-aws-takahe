resource "aws_db_subnet_group" "app" {
  name       = "takahe-${var.name}-app"
  subnet_ids = module.vpc.database_subnets
}

resource "random_password" "rds_app_root" {
  length  = 32
  special = false
}

resource "aws_db_instance" "app" {
  allocated_storage = 20
  db_name           = "takahe"

  identifier = "takahe-${var.name}-app"

  engine               = "postgres"
  engine_version       = "14.5"
  instance_class       = "db.t4g.micro"
  username             = "root"
  password             = random_password.rds_app_root.result
  parameter_group_name = "default.postgres14"
  skip_final_snapshot  = true

  multi_az = false

  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true

  apply_immediately = true

  availability_zone = "us-west-2a"

  backup_retention_period = 0
  backup_window           = "09:46-10:16"

  copy_tags_to_snapshot = true

  db_subnet_group_name = aws_db_subnet_group.app.name
  network_type         = "DUAL"

  storage_type = "gp2"

  vpc_security_group_ids = [aws_security_group.rds_app.id]
}
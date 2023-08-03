resource "aws_db_instance" "rds" {
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.medium"
  username             = var.db_user_d
  password             = var.db_password_d
  port                 = var.db_port
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

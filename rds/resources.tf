resource "aws_db_instance" "rds" {
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = base64decode(var.db_user)
  password             = base64decode(var.db_password)
  port                 = var.db_port
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

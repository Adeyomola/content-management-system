resource "aws_db_instance" "rds" {
  allocated_storage      = 10
  db_name                = var.db_name
  engine                 = "postgres"
  engine_version         = "15.3"
  instance_class         = "db.t3.medium"
  username               = var.db_user_d
  password               = var.db_password_d
  port                   = var.db_port
#  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  publicly_accessible    = true
}

resource "aws_security_group" "rds-sg" {

  name        = "rds-sg"
  description = "Allow MySQL Port"

  ingress {
    description = "Allowing Connection for SSH"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS"
  }
}

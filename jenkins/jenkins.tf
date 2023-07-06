data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name  = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "jenkins" {
  instance_type               = "t2.medium"
  ami                         = data.aws_ami.ubuntu.id
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  user_data                   = file("user_data.sh")
  associate_public_ip_address = true
  key_name                    = var.key_name
  root_block_device {
    volume_size = 15
  }
  tags = {
    Name = "jenkins-server"
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "allow incoming traffic on SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

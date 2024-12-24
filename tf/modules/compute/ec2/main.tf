resource "aws_security_group" "jenkins" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}

resource "aws_instance" "jenkins" {
  instance_type = "t3.micro"
  ami = "ami-0ed2f9fb6f6e1bde6"
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.jenkins.id]

  tags = {
    Name = "jenkins-master"
  }
}
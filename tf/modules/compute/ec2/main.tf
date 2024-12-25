resource "aws_security_group" "instance_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.ingress_from_port
    to_port     = var.ingress_to_port
    protocol    = var.ingress_protocol
    cidr_blocks = var.ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name
  }
}

resource "aws_instance" "instance" {
  instance_type          = var.instance_type
  ami                    = var.ami
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  key_name               = "omer_key"
  iam_instance_profile   = "jenkins"

  tags = {
    Name = var.instance_name
  }
}

# Uncomment if Elastic IP is required
# resource "aws_eip" "eip" {
#   domain = "vpc"
#   depends_on = [aws_instance.instance]
# }

# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = aws_instance.instance.id
#   allocation_id = aws_eip.eip.id
# }

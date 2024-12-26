terraform {
  backend "s3" {
    bucket         = "my-terraform-state-vpc"
    key            = "jenkins/terraform.tfstate"
    region         = "eu-north-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "my-terraform-state-vpc"
    key    = "vpc/terraform.tfstate"
    region = "eu-north-1"
  }
}

module "ec2" {
  source                  = "../modules/compute/ec2"
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_id               = data.terraform_remote_state.vpc.outputs.private_subnets[0]
  instance_type           = "t3.small"
  ami                     = "ami-05a860b39d42d1bb5"
  security_group_name     = "jenkins-sg"
  ingress_from_port       = 8080
  ingress_to_port         = 8080
  ingress_protocol        = "tcp"
  ingress_cidr_blocks     = ["0.0.0.0/0"]
  instance_name           = "jenkins-master"
}

module "alb" {
  source               = "../modules/compute/alb"
  vpc_id               = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnet_ids    = data.terraform_remote_state.vpc.outputs.public_subnets
  instance_id          = module.ec2.instance_id
  name                 = var.name
  load_balancer_type   = "application"
  ingress_from_port    = 8080
  ingress_to_port      = 8080
  target_group_port    = 8080
  health_check_port    = 8080
  protocol             = "HTTP"
  listener_port        = 8080
}

resource "aws_security_group" "jenkins_sg" {
  name        = var.security_group_name
  description = "Dynamic security group for Jenkins master"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}
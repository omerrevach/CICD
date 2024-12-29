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

module "jenkins_ec2" {
  source                  = "../modules/compute/ec2"
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_id               = data.terraform_remote_state.vpc.outputs.private_subnets[0]
  instance_type           = "t3.small"
  ami                     = "ami-089146c5626baa6bf"
  security_group_name     = "jenkins-sg"
  ingress_from_port       = 8080
  ingress_to_port         = 8080
  ingress_protocol        = "tcp"
  ingress_cidr_blocks     = ["0.0.0.0/0"]
  instance_name           = "jenkins-master"
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 50000
    to_port     = 50000
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
    Name = "jenkins-sg"
  }
}

resource "aws_security_group" "gitlab_sg" {
  name        = "gitlab-sg"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "gitlab-sg"
  }
}

module "gitlab_ec2" {
  source                  = "../modules/compute/ec2"
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_id               = data.terraform_remote_state.vpc.outputs.private_subnets[0]
  instance_type           = "t3.large"
  ami                     = "ami-089146c5626baa6bf"
  security_group_name     = "gitlab-sg"
  ingress_from_port       = 80
  ingress_to_port         = 80
  ingress_protocol        = "tcp"
  ingress_cidr_blocks     = ["0.0.0.0/0"]
  instance_name           = "gitlab-server"
}

module "alb" {
  source               = "../modules/compute/alb"

  name                 = "jenkins-gitlab-lb"
  vpc_id               = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnet_ids    = data.terraform_remote_state.vpc.outputs.public_subnets
  load_balancer_type   = "application"

  protocol             = "HTTP"
  ingress_from_port    = 80
  ingress_to_port      = 80

  target_groups = {
    gitlab = {
      port              = 80
      protocol          = "HTTP"
      health_check_path = "/-/health"
      health_check_port = 80
      instance_id       = module.gitlab_ec2.instance_id
      target_group_port = 80
    },
    jenkins = {
      port              = 8080
      protocol          = "HTTP"
      health_check_path = "/login"
      health_check_port = 8080
      instance_id       = module.jenkins_ec2.instance_id
      target_group_port = 8080
    }
  }

  listeners = {
    gitlab  = { port = 80, protocol = "HTTP", target_group_key = "gitlab" }
    jenkins = { port = 8080, protocol = "HTTP", target_group_key = "jenkins" }
  }
}
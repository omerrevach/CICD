module "vpc" {
  source      = "../modules/networking/vpc"
  cidr_block  = "10.0.0.0/16"
  name        = var.name
}

module "igw" {
  source = "../modules/networking/igw"
  vpc_id = module.vpc.vpc_id
  name   = var.name
}

module "subnets" {
  source        = "../modules/networking/subnets"
  vpc_id        = module.vpc.vpc_id
  public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  name          = var.name
}

module "nat" {
  source              = "../modules/networking/nat"
  vpc_id              = module.vpc.vpc_id
  instance_type       = "t3.micro"
  public_subnet_id    = module.subnets.public_subnets[0]
  private_cidr_blocks = module.subnets.private_cidr_blocks
  name                = var.name
}

module "route" {
  source                            = "../modules/networking/route_tables"
  vpc_id                            = module.vpc.vpc_id
  igw_id                            = module.igw.igw_id
  nat_instance_network_interface_id = module.nat.nat_instance_network_interface_id
  public_subnet_ids                  = module.subnets.public_subnets
  private_subnet_ids                 = module.subnets.private_subnets
  name                              = var.name
}

module "ec2" {
  source                  = "../modules/compute/ec2"
  vpc_id                  = module.vpc.vpc_id
  subnet_id               = module.subnets.private_subnets[0]
  instance_type           = "t3.small"
  ami                     = "ami-06d84abc599644ee1"
  security_group_name     = "jenkins-sg"
  ingress_from_port       = 8080
  ingress_to_port         = 8080
  ingress_protocol        = "tcp"
  ingress_cidr_blocks     = ["0.0.0.0/0"]
  instance_name           = "jenkins-master"
}

module "alb" {
  source               = "../modules/compute/alb"
  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.subnets.public_subnets
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
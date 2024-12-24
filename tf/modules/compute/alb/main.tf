resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id

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

  tags = {
    Name = "${var.name}-alb-sg"
  }
}

resource "aws_alb" "external_alb" {
  name               = "${var.name}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.name}-alb"
  }
}

resource "aws_lb_target_group" "target_group" {
  name = "leumi-TG"
  port = 8080
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    path = "/health"
    port = 8080
    protocol = "HTTP"
  }
}

resource "aws_lb_target_group_attachment" "leumi_instance" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.jenkins_instance_id
  port             = 8080

  depends_on = [
    aws_lb_target_group.target_group
  ]
}

resource "aws_lb_listener" "alb_listener_leumi" {
  load_balancer_arn = aws_alb.external_alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

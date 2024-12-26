resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.ingress_from_port
    to_port     = var.ingress_to_port
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
    Name = "${var.name}-lb-sg"
  }
}

resource "aws_lb" "external_lb" {
  name               = "${var.name}-lb"
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.name}-lb"
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "${var.name}-tg"
  port     = var.target_group_port
  protocol = var.protocol
  vpc_id   = var.vpc_id

  health_check {
    port     = var.health_check_port
    protocol = var.protocol

    path = var.protocol == "HTTP" || var.protocol == "HTTPS" ? "/health" : null
  }
}

resource "aws_lb_target_group_attachment" "target_group_attachment" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.instance_id
  port             = var.target_group_port
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.external_lb.arn
  port              = var.listener_port
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

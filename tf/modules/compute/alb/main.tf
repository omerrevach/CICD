resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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

  tags = {
    Name = "${var.name}-lb-sg"
  }
}

resource "aws_lb" "external_lb" {
  name               = "${var.name}-lb"
  load_balancer_type = var.load_balancer_type
  security_groups    = var.load_balancer_type == "application" ? [aws_security_group.alb_sg.id] : null
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.name}-lb"
  }
}

resource "aws_lb_listener" "http_listeners" {
  for_each = var.listeners

  load_balancer_arn = aws_lb.external_lb.arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_groups[each.value.target_group_key].arn
  }
}

resource "aws_lb_target_group" "target_groups" {
  for_each = var.target_groups

  name     = "${var.name}-${each.key}-tg"
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = var.vpc_id

  health_check {
    port                = each.value.health_check_port
    protocol            = each.value.protocol
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    path                = each.value.health_check_path
  }
}

resource "aws_lb_target_group_attachment" "target_group_attachments" {
  for_each = var.target_groups

  target_group_arn = aws_lb_target_group.target_groups[each.key].arn
  target_id        = each.value.instance_id
  port             = each.value.target_group_port
}

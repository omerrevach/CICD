output "alb_dns_name" {
  value = aws_lb.external_lb.dns_name
}

output "load_balancer_arn" {
  value = aws_lb.external_lb.arn
}

output "target_group_arns" {
  value = {
    for key, tg in aws_lb_target_group.target_groups :
    key => tg.arn
  }
}

output "listener_arns" {
  value = {
    for key, listener in aws_lb_listener.http_listeners :
    key => listener.arn
  }
}

output "security_group_id" {
  value = aws_security_group.alb_sg.id
}

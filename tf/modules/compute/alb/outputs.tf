output "alb_dns_name" {
  value       = aws_lb.external_lb.dns_name
}

output "load_balancer_arn" {
  value       = aws_lb.external_lb.arn
}

output "target_group_arn" {
  value       = aws_lb_target_group.target_group.arn
}

output "listener_arn" {
  value       = aws_lb_listener.listener.arn
}

output "security_group_id" {
  value       = aws_security_group.alb_sg.id
}

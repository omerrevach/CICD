output "jenkins_instance_id" {
  value       = module.jenkins.instance_id
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
}

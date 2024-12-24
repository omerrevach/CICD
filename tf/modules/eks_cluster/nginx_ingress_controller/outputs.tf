output "load_balancer_hostname" {
  description = "LoadBalancer hostname for the NGINX ingress controller"
  value       = try(data.kubernetes_service.nginx_ingress_controller.status.0.load_balancer.0.ingress.0.hostname)
}

output "namespace" {
  value       = var.ingress_namespace
}
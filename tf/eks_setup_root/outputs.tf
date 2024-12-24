output "argocd_server_url" {
  value       = module.argocd.argocd_server_url
  description = "The URL of the ArgoCD server LoadBalancer."
}
output "ingress_url" {
  description = "URL for the ArgoCD server ingress"
  value       = "http://${var.argocd_hostname}" # Replace with your hostname variable
}

output "namespace" {
  description = "namespace where ArgoCD is deployed"
  value       = var.argocd_namespace
}

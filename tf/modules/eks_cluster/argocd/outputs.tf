# output "argocd_server_url" {
#   value = helm_release.argocd.status["load_balancer_ingress"][0]["hostname"]
# }

output "namespace" {
  description = "namespace where ArgoCD is deployed"
  value       = var.argocd_namespace
}


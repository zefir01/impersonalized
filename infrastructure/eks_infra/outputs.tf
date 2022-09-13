output "argocd_admin_password" {
  value = module.argo.argocd_admin_password
  sensitive = true
}
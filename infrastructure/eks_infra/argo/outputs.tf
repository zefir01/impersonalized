output "argocd_admin_password" {
  value = random_password.password.result
}
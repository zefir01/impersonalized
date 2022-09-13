output "oidc_url" {
  value = module.eks.oidc_url
}
output "oidc_arn" {
  value = module.eks.oidc_arn
}
output "cluster_endpoint" {
  value =module.eks.cluster_endpoint
}
output "ng_iam_role_name" {
  value = module.eks.ng_iam_role_name
}
output "cluster_ca_certificate" {
  value = module.eks.cluster_ca_certificate
}
output "crossplane_irsa_arn" {
  value = module.eks.crossplane_irsa_arn
}
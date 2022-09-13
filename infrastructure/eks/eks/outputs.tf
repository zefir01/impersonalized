output "oidc_url" {
  value = module.eks.oidc_provider
}
output "oidc_arn" {
  value = module.eks.oidc_provider_arn
}

output "cluster_endpoint" {
  value =module.eks.cluster_endpoint
}

data "aws_eks_cluster_auth" "aws_iam_authenticator" {
  name = module.eks.cluster_id
}

output "cluster_token" {
  value = data.aws_eks_cluster_auth.aws_iam_authenticator.token
}

output "cluster_ca_certificate" {
  value = base64decode(module.eks.cluster_certificate_authority_data)
}

output "ng_iam_role_name" {
  value = try(module.eks.eks_managed_node_groups.main.iam_role_name, "")
}

output "crossplane_irsa_arn" {
  value = module.eks.crossplane_irsa_arn
}
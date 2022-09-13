module "crossplane_irsa" {
  source         = "../../../irsa"
  name           = "crossplane-aws"
  cluster_name   = var.cluster_name
  namespace      = "crossplane-system"
  serviceaccount = "provider-aws-*"
  oidc_url       = replace(aws_eks_cluster.this[0].identity[0].oidc[0].issuer, "https://", "")
  oidc_arn       = aws_iam_openid_connect_provider.oidc_provider[0].arn
  policy_arns    = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  tags           = var.tags
  sa_wildcard    = true
}

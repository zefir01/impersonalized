resource "random_string" "random" {
  length  = 8
  special = false
  lower   = true
  number  = true
  upper   = false
}

#module "irsa" {
#  source         = "Young-ook/eks/aws//modules/iam-role-for-serviceaccount"
#  name           = "irsa-${var.cluster_name}-${var.name}-${random_string.random.result}"
#  namespace      = var.namespace
#  serviceaccount = var.serviceaccount
#  oidc_url       = replace(var.oidc_url, "https://", "")
#  oidc_arn       = var.oidc_arn
#  policy_arns    = var.policy_arns
#  tags           = var.tags
#}


locals {
  oidc_fully_qualified_subjects = format("system:serviceaccount:%s:%s", var.namespace, var.serviceaccount)
}


locals {
  name         = substr("irsa-${var.cluster_name}-${var.name}-${random_string.random.result}", 0, 64)
  default-tags = merge(
    { "Name" = local.name },
  )
}

resource "aws_iam_role" "irsa" {
  name               = local.name
  path               = "/"
  tags               = merge(local.default-tags, var.tags)
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action    = "sts:AssumeRoleWithWebIdentity"
        Effect    = "Allow"
        Principal = {
          Federated = var.oidc_arn
        }
        Condition = var.sa_wildcard ? {
          StringLike = {
            format("%s:sub", replace(var.oidc_url, "https://", "")) = local.oidc_fully_qualified_subjects
          }
        } : {
          StringEquals = {
            format("%s:sub", replace(var.oidc_url, "https://", "")) = local.oidc_fully_qualified_subjects
          }
        }
      }
    ]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "irsa" {
  for_each   = {for key, val in var.policy_arns : key => val}
  policy_arn = each.value
  role       = aws_iam_role.irsa.name
}


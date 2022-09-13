module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 4"

  for_each = toset(local.users)

  name          = each.key
  force_destroy = true

  #pgp_key = "keybase:test"

  password_reset_required = false
  create_iam_access_key   = false
}

module "iam_group_with_policies" {
  depends_on = [module.iam_user]
  source     = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version    = "~> 4"

  name = "cloudwatch"

  group_users = local.users

  attach_iam_self_management_policy = true

  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess",
  ]
}

data "aws_caller_identity" "current" {}

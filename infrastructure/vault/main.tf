resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

locals {
  kms_key_name   = "${var.stack}-vault-kms-unseal"
  s3_bucket_name = "${var.stack}-vault-${random_string.random.result}"
  sa_name        = "vault"
  sa_namespace   = "vault"
  table_name     = "${var.stack}-vault"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.arn]
    }
    actions = [
      "kms:*",
    ]
    resources = [
      "*",
    ]
  }


  statement {
    principals {
      type        = "AWS"
      identifiers = [module.irsa.arn]
    }
    actions = [
      "kms:*",
    ]
    resources = [
      "*",
    ]
  }
}

module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name                               = local.table_name
  hash_key                           = "Path"
  range_key                          = "Key"
  server_side_encryption_kms_key_arn = aws_kms_key.vault.arn
  server_side_encryption_enabled     = true

  attributes = [
    {
      name = "Path"
      type = "S"
    },
    {
      name = "Key"
      type = "S"
    }
  ]

  tags = var.tags
}

resource "aws_kms_key" "vault" {
  description             = "Vault unseal key"
  deletion_window_in_days = 10
  policy                  = data.aws_iam_policy_document.kms_key_policy.json

  tags = {
    Name  = local.kms_key_name
    Stack = var.stack
  }
}

data "aws_iam_policy_document" "vault" {
  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey",
      "kms:Get*",
      "kms:ReEncrypt*",
    ]
    resources = [aws_kms_key.vault.arn]
  }

  statement {
    actions = [
      "kms:ListKeys",
      "kms:ListAliases",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    actions   = ["s3:*"]
    resources = [module.s3_bucket.s3_bucket_arn]
  }

  statement {
    actions = [
      "ec2:DescribeInstances",
      "iam:GetInstanceProfile",
      "iam:GetUser",
      "iam:GetRole"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:ListTagsOfResource",
      "dynamodb:DescribeReservedCapacityOfferings",
      "dynamodb:DescribeReservedCapacity",
      "dynamodb:ListTables",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:CreateTable",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:Scan",
      "dynamodb:DescribeTable"
    ]
    resources = [module.dynamodb_table.dynamodb_table_arn]
  }
}

resource "aws_iam_policy" "vault-kms-unseal" {
  name_prefix = "${var.stack}-eks-vault"
  policy      = data.aws_iam_policy_document.vault.json
}

module "irsa" {
  source         = "../irsa"
  name           = "${var.stack}-vault-kms-unseal"
  cluster_name   = var.cluster_name
  namespace      = local.sa_name
  serviceaccount = local.sa_namespace
  oidc_url       = var.oidc_url
  oidc_arn       = var.oidc_arn
  policy_arns    = [aws_iam_policy.vault-kms-unseal.arn]
  tags           = var.tags
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [module.irsa.arn]
    }

    actions = [
      "s3:*",
    ]

    resources = [
      module.s3_bucket.s3_bucket_arn,
      "${module.s3_bucket.s3_bucket_arn}/*",
    ]
  }
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                  = local.s3_bucket_name
  acl                     = "public-read-write"
  force_destroy           = true
  restrict_public_buckets = true

  attach_policy                         = true
  policy                                = data.aws_iam_policy_document.bucket_policy.json
  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true
  attach_public_policy                  = false

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }

}
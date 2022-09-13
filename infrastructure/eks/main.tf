terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}


locals {
  instance_type = "t3.large"
  domain        = "blablablaapis.codes"
}
data "aws_region" "current" {}

data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_iam_role" "github" {
  name = "github-actions"
}

module "eks" {
  source               = "./eks"
  stack                = var.stack
  vpc_id               = var.vpc_id
  region               = data.aws_region.current.name
  main_instance_type   = local.instance_type
  subnets              = var.private_subnets
  partition            = data.aws_partition.current.partition
  partition_dns_suffix = data.aws_partition.current.dns_suffix
  account_id           = data.aws_caller_identity.current.account_id
  main_instance_count  = var.main_instance_count
  github_role_arn      = data.aws_iam_role.github.arn
}
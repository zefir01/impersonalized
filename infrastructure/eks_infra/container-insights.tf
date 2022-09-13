## kubernetes container-insights


locals {
  suffix = random_string.containerinsights-suffix.result
}

#module "irsa-metrics" {
#  source         = "../irsa"
#  name           = "amazon-cloudwatch"
#  cluster_name   = var.cluster_name
#  namespace      = "amazon-cloudwatch"
#  serviceaccount = "amazon-cloudwatch"
#  oidc_url       = var.oidc_url
#  oidc_arn       = var.oidc_arn
#  policy_arns    = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]
#  tags           = var.tags
#}
#
#resource "helm_release" "metrics" {
#  name             = "aws-cloudwatch-metrics"
#  chart            = "aws-cloudwatch-metrics"
#  version          = null
#  repository       = "https://aws.github.io/eks-charts"
#  namespace        = "amazon-cloudwatch"
#  create_namespace = true
#  cleanup_on_fail  = true
#
#  dynamic "set" {
#    for_each = {
#      "clusterName"                                               = var.cluster_name
#      "serviceAccount.name"                                       = "amazon-cloudwatch"
#      "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.irsa-metrics.arn
#      "replicaCount"                                              = var.replicas
#    }
#    content {
#      name  = set.key
#      value = set.value
#    }
#  }
#}

module "irsa-logs" {
  source         = "../irsa"
  name           = "aws-for-fluent-bit"
  cluster_name = var.cluster_name
  namespace      = "kube-system"
  serviceaccount = "aws-for-fluent-bit"
  oidc_url       = var.oidc_url
  oidc_arn       = var.oidc_arn
  policy_arns    = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]
  tags           = var.tags
}

resource "helm_release" "logs" {
  name            = "aws-for-fluent-bit"
  chart           = "aws-for-fluent-bit"
  version         = null
  repository      = "https://aws.github.io/eks-charts"
  namespace       = "kube-system"
  cleanup_on_fail = true

  dynamic "set" {
    for_each = {
      "cloudWatch.enabled"                                        = true
      "cloudWatch.region"                                         = var.region
      "cloudWatch.logGroupName"                                   = format("/aws/containerinsights/%s/application", var.cluster_name)
      "firehose.enabled"                                          = false
      "kinesis.enabled"                                           = false
      "elasticsearch.enabled"                                     = false
      "serviceAccount.name"                                       = "aws-for-fluent-bit"
      "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.irsa-logs.arn
      "replicaCount"                                              = var.replicas
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "random_string" "containerinsights-suffix" {
  length  = 5
  upper   = false
  lower   = true
  number  = false
  special = false
}


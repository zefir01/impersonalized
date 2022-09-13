resource "aws_iam_policy" "this" {
  name_prefix = "prometheus"
  policy      = <<EOF
{
  "Version": "2012-10-17",
   "Statement": [
       {"Effect": "Allow",
        "Action": [
           "aps:QueryMetrics",
           "aps:GetSeries",
           "aps:GetLabels",
           "aps:GetMetricMetadata"
        ],
        "Resource": "*"
      }
   ]
}
EOF
}

module "irsa-grafana" {
  source         = "../../irsa"
  name           = "grafana"
  cluster_name   = var.cluster_name
  namespace      = "grafana"
  serviceaccount = "grafana-serviceaccount"
  oidc_url       = var.oidc_url
  oidc_arn       = var.oidc_arn
  policy_arns    = [aws_iam_policy.this.arn]
  tags           = var.tags
}

#resource "helm_release" "grafana-operator" {
#  name             = "grafana-operator"
#  chart            = "grafana-operator"
#  repository       = "https://charts.bitnami.com/bitnami"
#  namespace        = "grafana"
#  create_namespace = true
#  cleanup_on_fail  = true
#
#  dynamic "set" {
#    for_each = {
#      "operator.serviceAccount.name"                                      = "grafana-operator"
#      "operator.replicaCount"                                             = var.replicas
#      "operator.scanAllNamespaces"                                        = true
#      "operator.prometheus.serviceMonitor.enabled"                        = false
#      "grafana.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.irsa-grafana.arn
#      "grafana.replicaCount"                                              = var.replicas
#      "grafana.enabled"                                                   = false
#    }
#    content {
#      name  = set.key
#      value = set.value
#    }
#  }
#}
#
#module "path_hash" {
#  source = "github.com/claranet/terraform-path-hash?ref=v1.0.0"
#  path   = "${path.module}/charts/grafana"
#}
#
#resource "helm_release" "grafana" {
#  depends_on       = [helm_release.grafana-operator, module.acm]
#  name             = var.service_name
#  version          = null
#  chart            = "${path.module}/charts/grafana"
#  namespace        = "grafana"
#  create_namespace = true
#  cleanup_on_fail  = true
#
#  dynamic "set" {
#    for_each = {
#      "ampEndpoint"  = var.amp_endpoint
#      "region"       = var.region
#      "roleArn"      = module.irsa-grafana.arn
#      "serviceName"  = var.service_name
#      "domain"       = var.domain
#      "replicaCount" = var.replicas
#      "stack"        = var.stack
#      "hash"         = module.path_hash.result
#    }
#    content {
#      name  = set.key
#      value = set.value
#    }
#  }
#
#}
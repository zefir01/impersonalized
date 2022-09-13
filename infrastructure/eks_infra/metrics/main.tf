resource "aws_iam_policy" "this" {
  name_prefix = "prometheus"
  policy      = <<EOF
{
  "Version": "2012-10-17",
   "Statement": [
       {"Effect": "Allow",
        "Action": [
           "aps:RemoteWrite",
           "aps:GetSeries",
           "aps:GetLabels",
           "aps:GetMetricMetadata",

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

module "irsa" {
  source         = "../../irsa"
  name           = "prometheus"
  cluster_name   = var.cluster_name
  namespace      = "prometheus"
  serviceaccount = "prometheus-server"
  oidc_url       = var.oidc_url
  oidc_arn       = var.oidc_arn
  policy_arns    = [aws_iam_policy.this.arn]
  tags           = var.tags
}

resource "aws_prometheus_workspace" "this" {
  alias = "prometheus-${var.stack}"
  tags  = var.tags
}

/*
resource "helm_release" "prometheus-operator" {
  name             = "prometheus-operator"
  chart            = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  namespace        = "prometheus"
  create_namespace = true
  cleanup_on_fail  = true

  dynamic "set" {
    for_each = {
      "kubeApiServer.enabled"                                                       = false
      "prometheus.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"        = module.irsa.arn
      "prometheus.serviceAccount.name"                                              = "prometheus-server"
      "grafana.enabled"                                                             = false
      "alertmanager.enabled"                                                        = false
      "prometheus.prometheusSpec.remoteWrite[0].url"                                = "${aws_prometheus_workspace.this.prometheus_endpoint}api/v1/remote_write"
      "prometheus.prometheusSpec.remoteWrite[0].sigv4.region"                       = var.region
      "prometheus.prometheusSpec.remoteWrite[0].writeRelabelConfigs[0].targetLabel" = "cluster_name"
      "prometheus.prometheusSpec.remoteWrite[0].writeRelabelConfigs[0].replacement" = var.cluster_name
      "prometheus.prometheusSpec.retention"                                         = "3h"
      //"serverFiles.\"prometheus.yml\".scrape_configs[1].kubernetes_sd_configs"
    }
    content {
      name  = set.key
      value = set.value
    }

  }
}


resource "helm_release" "metrics-server" {
  name             = "metrics-server"
  chart            = "metrics-server"
  repository       = "https://kubernetes-sigs.github.io/metrics-server"
  namespace        = "kube-system"
  create_namespace = false
  cleanup_on_fail  = true

  dynamic "set" {
    for_each = {
      "replicas" = var.replicas
    }
    content {
      name  = set.key
      value = set.value
    }

  }
}
*/
output "prometheus_endpoint" {
  value = aws_prometheus_workspace.this.prometheus_endpoint
}

terraform {
  required_providers {
    helm       = {}
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
  }
}

locals {
  aws_alb_ingress_controller_docker_image = "docker.io/amazon/aws-alb-ingress-controller:v${var.aws_alb_ingress_controller_version}"
  aws_alb_ingress_controller_version      = var.aws_alb_ingress_controller_version
  aws_alb_ingress_class                   = "alb"
}


resource "aws_iam_policy" "this" {
  policy      = file("${path.module}/policy.json")
  description = "Permissions that are required to manage AWS Application Load Balancers."
  tags        = var.tags
}

module "irsa" {
  source         = "../../irsa"
  name           = "alb-cloudwatch"
  cluster_name   = var.k8s_cluster_name
  namespace      = var.k8s_namespace
  serviceaccount = "aws-alb-ingress-controller"
  oidc_url       = var.oidc_url
  oidc_arn       = var.oidc_arn
  policy_arns    = [aws_iam_policy.this.arn]
  tags           = var.tags
}

resource "kubernetes_service_account" "this" {
  automount_service_account_token = true
  metadata {
    name        = "aws-alb-ingress-controller"
    namespace   = var.k8s_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.irsa.arn
    }
    labels = {
      "app.kubernetes.io/name"       = "aws-alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "kubernetes_cluster_role" "this" {
  metadata {
    name = "aws-alb-ingress-controller"

    labels = {
      "app.kubernetes.io/name"       = "aws-alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  rule {
    api_groups = [
      "",
      "extensions",
    ]

    resources = [
      "configmaps",
      "endpoints",
      "events",
      "ingresses",
      "ingresses/status",
      "services",
    ]

    verbs = [
      "create",
      "get",
      "list",
      "update",
      "watch",
      "patch",
    ]
  }

  rule {
    api_groups = [
      "",
      "extensions",
    ]

    resources = [
      "nodes",
      "pods",
      "secrets",
      "services",
      "namespaces",
    ]

    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = "aws-alb-ingress-controller"

    labels = {
      "app.kubernetes.io/name"       = "aws-alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.this.metadata[0].name
  }

  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata[0].name
    namespace = kubernetes_service_account.this.metadata[0].namespace
  }
}


resource "helm_release" "this" {
  name             = "aws-load-balancer-controller"
  chart            = "aws-load-balancer-controller"
  version          = null
  repository       = "https://aws.github.io/eks-charts"
  namespace        = "kube-system"
  create_namespace = false
  cleanup_on_fail  = true

  dynamic "set" {
    for_each = {
      "clusterName"           = var.k8s_cluster_name
      "serviceAccount.create" = "false"
      "serviceAccount.name"   = kubernetes_service_account.this.metadata[0].name
      "replicaCount"          = var.k8s_replicas
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}
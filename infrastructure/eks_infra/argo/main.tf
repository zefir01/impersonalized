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


resource "random_password" "password" {
  length  = 16
  special = false
}

resource "helm_release" "argo-cd" {
  depends_on       = [module.acm]
  name             = "argo-cd"
  chart            = "argo-cd"
  version          = "4.5.1"
  repository       = "https://argoproj.github.io/argo-helm"
  namespace        = "argo"
  create_namespace = true
  cleanup_on_fail  = true


  lifecycle {
    ignore_changes = [set]
  }

  dynamic "set" {
    for_each = {
      "configs.secret.argocdServerAdminPassword"                                          = bcrypt(random_password.password.result)
      "server.extraArgs[0]"                                                               = "--insecure"
      "server.ingress.enabled"                                                            = true
      "server.ingress.hosts[0]"                                                           = "argo.${var.stack}.${var.domain}"
      "server.ingress.ingressClassName"                                                   = "alb"
      "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"                 = "internet-facing"
      "server.ingress.annotations.external-dns\\.kubernetes\\.io/enable"                  = "true"
      "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/listen-ports"           = "\\[{\"HTTPS\":443}\\]"
      "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/load-balancer-name"     = "argo-${var.stack}"
      "server.ingress.https"                                                              = false
      "server.ingress.tls[0].hosts[0]"                                                    = "argo.${var.stack}.${var.domain}"
      "server.ingress.tls[0].secretName"                                                  = "myingress-cert"
      "server.service.type"                                                               = "NodePort"
      "server.ingressGrpc.isAWSALB"                                                       = true
      "server.ingressGrpc.enabled"                                                        = true
      "server.ingressGrpc.hosts[0]"                                                       = "argo-grpc.${var.stack}}.${var.domain}"
      "server.ingressGrpc.ingressClassName"                                               = "alb"
      "server.ingressGrpc.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"             = "internet-facing"
      "server.ingressGrpc.annotations.alb\\.ingress\\.kubernetes\\.io/listen-ports"       = "\\[{\"HTTPS\":443}\\]"
      "server.ingressGrpc.annotations.external-dns\\.kubernetes\\.io/enable"              = "true"
      "server.ingressGrpc.annotations.alb\\.ingress\\.kubernetes\\.io/load-balancer-name" = "argo-grpc-${var.stack}"
      "server.ingressGrpc.awsALB.serviceType"                                             = "NodePort"
      "server.ingressGrpc.https"                                                          = false
      "controller.replicas"                                                               = var.replicas
      "repoServer.replicas"                                                               = var.replicas
      "server.replicas"                                                                   = var.replicas
      "global.podAnnotations.fluentbit.io/exclude"                                        = "true"
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}

data "aws_caller_identity" "current" {}

resource "kubectl_manifest" "argo-base" {
  depends_on = [helm_release.argo-cd]
  yaml_body  = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: argo-base
  namespace: argo
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  annotations:
    argocd.argoproj.io/sync-options: SkipDryRunOnMissingResource=true
spec:
  project: default
  source:
    repoURL: git@github.com:blablabla/argocd
    targetRevision: main
    path: apps
    directory:
      recurse: false
      jsonnet:
        extVars:
        - name: crossplane_irsa_arn
          value: ${var.crossplane_irsa_arn}
        - name: region
          value: ${var.region}
        - name: cluster_name
          value: ${var.cluster_name}
        - name: amp_url
          value: ${var.amp_url}
        - name: prometheus_irsa_arn
          value: ${var.prometheus_irsa_arn}
        - name: grafana_irsa_arn
          value: ${var.grafana_irsa_arn}
        - name: blablabla_db_url
          value: ${var.blablabla_db_url}
        - name: blablabla_back_domain
          value: ${var.blablabla_back_domain}
        - name: blablabla_front_domain
          value: ${var.blablabla_front_domain}
        - name: env
          value: ${var.env}
        - name: account_id
          value: "${data.aws_caller_identity.current.account_id}"
        - name: metabase_user
          value: ${var.metabase_user}
        - name: metabase_password
          value: ${var.metabase_password}
        - name: metabase_db
          value: ${var.metabase_db}
        - name: metabase_db_host
          value: ${var.metabase_db_host}
        - name: polkadot_db_user
          value: ${var.polkadot_db_user}
        - name: polkadot_db_pass
          value: ${var.polkadot_db_pass}
        - name: polkadot_db_host
          value: ${var.polkadot_db_host}
        - name: polkadot_db_name
          value: ${var.polkadot_db_name}
        - name: squid_polkadot_db_user
          value: ${var.squid_polkadot_db_user}
        - name: squid_polkadot_db_pass
          value: ${var.squid_polkadot_db_pass}
        - name: squid_polkadot_db_host
          value: ${var.squid_polkadot_db_host}
        - name: squid_polkadot_db_name
          value: ${var.squid_polkadot_db_name}
  destination:
    server: https://kubernetes.default.svc
    namespace: blablabla
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
      - SkipDryRunOnMissingResource=true
    retry:
      limit: -1
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
YAML
}

resource "kubernetes_secret_v1" "argo_repo" {
  depends_on = [helm_release.argo-cd]
  metadata {
    name      = "argocd-repo"
    namespace = "argo"
    labels    = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    type          = "git"
    url           = "git@github.com:blablabla/argocd"
    sshPrivateKey = file("${path.module}/keys/argocd_deploy")
  }
}

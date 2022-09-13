terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    helm       = {}
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10.0"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = var.cluster_ca
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.stack]
      command     = "aws"
    }
  }
}

provider "kubectl" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = var.cluster_ca
  load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.stack]
    command     = "aws"
  }
}

provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = var.cluster_ca
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.stack]
    command     = "aws"
  }
}

module "alb" {
  source                             = "./alb"
  aws_alb_ingress_controller_version = "2.4.1"
  providers                          = {
    helm = helm
  }
  k8s_namespace    = "kube-system"
  aws_region_name  = var.region
  k8s_cluster_name = var.cluster_name
  oidc_url         = var.oidc_url
  oidc_arn         = var.oidc_arn
  k8s_replicas     = var.replicas
  tags             = merge(var.tags, {
    "k8s_ingress" = var.cluster_name
  })
}

module "irsa_external_dns" {
  source         = "../irsa"
  name           = "externaldns"
  cluster_name   = var.cluster_name
  namespace      = "kube-system"
  serviceaccount = "external-dns"
  oidc_url       = var.oidc_url
  oidc_arn       = var.oidc_arn
  policy_arns    = ["arn:aws:iam::aws:policy/AmazonRoute53FullAccess"]
  tags           = var.tags
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  chart            = "external-dns"
  version          = "6.4.0"
  repository       = "https://charts.bitnami.com/bitnami"
  namespace        = "kube-system"
  create_namespace = false
  cleanup_on_fail  = true

  dynamic "set" {
    for_each = {
      "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.irsa_external_dns.arn
      "provider" : "aws"
      "registry" : "txt"
      "txtOwnerId" : "eks-cluster"
      "txtPrefix" : "external-dns"
      "policy" : "sync"
      "publishInternalServices" : "true"
      "triggerLoopOnEvent" : "true"
      "interval" : "5s"
      "extraArgs.annotation-filter=external-dns.kubernetes.io/enable" : "true"
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}

#https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrating_csi_driver.html

resource "helm_release" "secrets" {
  name             = "csi-secrets-store"
  chart            = "secrets-store-csi-driver"
  version          = null
  repository       = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  namespace        = "kube-system"
  create_namespace = false
  cleanup_on_fail  = true

  dynamic "set" {
    for_each = {
      "replicaCount" = var.replicas
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}

module "metrics" {
  source       = "./metrics"
  oidc_url     = var.oidc_url
  oidc_arn     = var.oidc_arn
  replicas     = var.replicas
  tags         = var.tags
  cluster_name = var.cluster_name
  region       = var.region
  stack        = var.stack
  domain       = var.domain
}

module "grafana" {
  source       = "./grafana"
  oidc_url     = var.oidc_url
  oidc_arn     = var.oidc_arn
  region       = var.region
  replicas     = var.replicas
  tags         = var.tags
  cluster_name = var.cluster_name
  stack        = var.stack
  amp_endpoint = module.metrics.prometheus_endpoint
  domain       = var.domain
}

module "argo" {
  source                = "./argo"
  replicas              = var.replicas
  domain                = var.domain
  stack                 = var.stack
  oidc_url              = var.oidc_url
  oidc_arn              = var.oidc_arn
  tags                  = var.tags
  cluster_name          = var.cluster_name
  region                = var.region
  prometheus_irsa_arn   = module.metrics.prometheus_irsa_arn
  amp_url               = module.metrics.amp_url
  grafana_irsa_arn      = module.grafana.irsa_arn
  crossplane_irsa_arn   = var.crossplane_irsa_arn
  blablabla_db_url       = var.blablabla_db_url
  blablabla_back_domain  = var.blablabla_back_domain
  blablabla_front_domain = var.blablabla_front_domain
  env                   = var.env
  metabase_user         = var.metabase_user
  metabase_password     = var.metabase_password
  metabase_db           = var.metabase_db
  metabase_db_host      = var.metabase_db_host
  polkadot_db_user      = var.polkadot_db_user
  polkadot_db_pass      = var.polkadot_db_pass
  polkadot_db_host      = var.polkadot_db_host
  polkadot_db_name      = var.polkadot_db_name

  squid_polkadot_db_user = var.squid_polkadot_db_user
  squid_polkadot_db_pass = var.squid_polkadot_db_pass
  squid_polkadot_db_host = var.squid_polkadot_db_host
  squid_polkadot_db_name = var.squid_polkadot_db_name
}

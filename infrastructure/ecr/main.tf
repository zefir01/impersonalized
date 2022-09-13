locals {
  repos_blablabla=[
    "blablabla-app",
    "blablabla-api",
    "infrastructure-gear-node",
    "otelcol-custom-istio-awsxray",
    "provider-kubernetes",
    "provider-helm",
    "squid"
  ]
  repos_blablabla1=[
    "blablabla1-frontend"
  ]
}

module "this" {
  count = length(local.repos_blablabla)
  source = "./ecr_repo"
  organization = "blablabla"
  repo = local.repos_blablabla[count.index]
}

module "blablabla1" {
  count = length(local.repos_blablabla1)
  source = "./ecr_repo"
  organization = "blablabla1network"
  repo = local.repos_blablabla1[count.index]
}

output "repos_blablabla" {
  value = module.this
}

output "repos_blablabla1" {
  value = module.blablabla1
}
include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc/"
}

dependency "domain" {
  config_path = "../domain"
}

dependency "eks" {
  config_path = "../eks"
}

terraform {
  source = "path_relative_to_include()/../../../..//rds/"
}

inputs = {
  db_subnet_group_name = dependency.vpc.outputs.db_subnet_group
  vpc_id               = dependency.vpc.outputs.vpc_id
  cluster_endpoint     = dependency.eks.outputs.cluster_endpoint
  cluster_ca           = dependency.eks.outputs.cluster_ca_certificate
  oidc_url             = dependency.eks.outputs.oidc_url
  oidc_arn             = dependency.eks.outputs.oidc_arn
  domain               = dependency.domain.outputs.main_domain
}
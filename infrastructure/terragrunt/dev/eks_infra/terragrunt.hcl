include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "path_relative_to_include()/../../../..//eks_infra/"
}

dependency "domain" {
  config_path = "../domain"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "eks" {
  config_path = "../eks"
}

dependency "rds" {
  config_path = "../rds"
}

inputs = {
  cluster_endpoint             = dependency.eks.outputs.cluster_endpoint
  cluster_ca                   = dependency.eks.outputs.cluster_ca_certificate
  cluster_worker_iam_role_name = dependency.eks.outputs.ng_iam_role_name
  karpenter_instance_type      = "t3.large"
  oidc_url                     = dependency.eks.outputs.oidc_url
  oidc_arn                     = dependency.eks.outputs.oidc_arn
  domain                       = dependency.domain.outputs.main_domain
  vpc_id                       = dependency.vpc.outputs.vpc_id
  crossplane_irsa_arn          = dependency.eks.outputs.crossplane_irsa_arn
  blablabla_db_url              = dependency.rds.outputs.db_url

  metabase_user     = dependency.rds.outputs.metabase_user
  metabase_password = dependency.rds.outputs.metabase_password
  metabase_db       = dependency.rds.outputs.metabase_db
  metabase_db_host  = dependency.rds.outputs.metabase_db_host

  polkadot_db_user = dependency.rds.outputs.polkadot_db_user
  polkadot_db_pass = dependency.rds.outputs.polkadot_db_pass
  polkadot_db_host = dependency.rds.outputs.polkadot_db_host
  polkadot_db_name = dependency.rds.outputs.polkadot_db_name

  squid_polkadot_db_user = dependency.rds.outputs.squid_polkadot_db_user
  squid_polkadot_db_pass = dependency.rds.outputs.squid_polkadot_db_pass
  squid_polkadot_db_host = dependency.rds.outputs.squid_polkadot_db_host
  squid_polkadot_db_name = dependency.rds.outputs.squid_polkadot_db_name
}
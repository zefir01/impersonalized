include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "path_relative_to_include()/../../../..//eks/"
}

dependency "vpc" {
  config_path = "../vpc/"
}

dependency "domain" {
  config_path  = "../domain"
  skip_outputs = true
}


inputs = {
  vpc_id              = dependency.vpc.outputs.vpc_id
  private_subnets     = dependency.vpc.outputs.private_subnets
  public_subnets      = dependency.vpc.outputs.public_subnets
  main_instance_count = 2
}
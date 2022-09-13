include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "path_relative_to_include()/../../../..//cloudfront/"
}

dependency "domain" {
  config_path = "../domain"
}

inputs = {
  domain = "blablabla.network"
  app_domain = "blablabla.network"
  api_domain = "blablablaapis.network"
}
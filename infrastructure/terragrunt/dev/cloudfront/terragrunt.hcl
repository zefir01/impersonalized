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
  domain = "blablabla.codes"
  app_domain = "blablabla.codes"
  api_domain = "blablablaapis.codes"
}
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "path_relative_to_include()/../../../..//lambdas/"
}

inputs = {
  url        = "https://frontend.blablabla.network"
  alarm_name = "Prod Frontend"
}
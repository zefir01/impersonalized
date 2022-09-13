include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "path_relative_to_include()/../../../..//vpc/"
}

inputs = {
  public_db_subnets = true
}
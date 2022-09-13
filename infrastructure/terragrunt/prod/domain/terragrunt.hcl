include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "path_relative_to_include()/../../../..//domain/"
}
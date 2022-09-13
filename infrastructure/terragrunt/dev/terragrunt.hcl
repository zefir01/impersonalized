# Indicate what region to deploy the resources into
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "eu-central-1"
}
EOF
}

remote_state {
  backend  = "s3"
  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "blablabla-terragrunt-state"

    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "my-lock-table"
  }
}

inputs = {
  stack                 = "main"
  vpc_name              = "main"
  cluster_name          = "main"
  replicas              = 1
  region                = "eu-central-1"
  zones                 = ["blablablaapis.codes", "blablabla.codes", "blablabla1.codes", "blablabla2.codes"]
  blablabla_front_domain = "app.blablabla.codes"
  blablabla_back_domain  = "app.blablablaapis.codes"
  env                   = "dev"
}
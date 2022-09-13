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
    bucket = "blablabla-terragrunt-prod"

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
  zones                 = ["blablablaapis.network", "blablabla.network", "blablabla1.network", "blablabla2.network"]
  blablabla_front_domain = "app.blablabla.network"
  blablabla_back_domain  = "app.blablablaapis.network"
  env                   = "dev"
}
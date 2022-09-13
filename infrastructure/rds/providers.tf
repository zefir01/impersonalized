terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.16.0"
    }
  }
}


provider "postgresql" {
  host            = module.db.db_instance_address
  port            = 5432
  database        = local.db_name
  username        = local.username
  password        = module.db.db_instance_password
  sslmode         = "require"
  connect_timeout = 15
  superuser       = false
  scheme          = "awspostgres"
}
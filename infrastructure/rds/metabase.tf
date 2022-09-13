resource "random_password" "metabase" {
  length           = 16
}

resource "postgresql_role" "metabase" {
  name     = "metabase"
  login    = true
  password = random_password.metabase.result
}

resource "postgresql_database" "metabase" {
  name              = "metabase"
  owner             = postgresql_role.metabase.name
  template          = "template0"
  lc_collate        = "C"
  connection_limit  = -1
  allow_connections = true
}
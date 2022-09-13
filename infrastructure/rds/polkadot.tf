resource "random_password" "polkadot" {
  length  = 32
  special = false
}

resource "postgresql_role" "polkadot" {
  name            = "polkadot"
  login           = true
  password        = random_password.polkadot.result
  create_database = true
}

resource "postgresql_database" "polkadot" {
  name              = "polkadot"
  owner             = postgresql_role.polkadot.name
  template          = "template0"
  lc_collate        = "C"
  connection_limit  = -1
  allow_connections = true
}
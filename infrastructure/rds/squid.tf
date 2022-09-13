resource "random_password" "squid_polkadot" {
  length  = 32
  special = false
}

resource "postgresql_role" "squid_polkadot" {
  name            = "squid_polkadot"
  login           = true
  password        = random_password.squid_polkadot.result
  create_database = true
}

resource "postgresql_database" "squid_polkadot" {
  name              = "squid_polkadot"
  owner             = postgresql_role.squid_polkadot.name
  template          = "template0"
  lc_collate        = "C"
  connection_limit  = -1
  allow_connections = true
}
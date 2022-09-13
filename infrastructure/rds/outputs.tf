#output "monitoring_role" {
#  value = module.db.
#}

output "db_user" {
  value = local.username
}
output "db_pass" {
  value = module.db.db_instance_password
  sensitive = true
}
output "db_name" {
  value = local.db_name
}
output "db_endpoint" {
  value = module.db.db_instance_endpoint
}
output "db_url" {
  value = "postgresql://${local.username}:${module.db.db_instance_password}@${module.db.db_instance_endpoint}/${local.db_name}?schema=public"
  sensitive = true
}

output "metabase_user" {
  value = postgresql_role.metabase.name
}
output "metabase_password" {
  value = random_password.metabase.result
  sensitive = true
}
output "metabase_db" {
  value = postgresql_database.metabase.name
}
output "metabase_db_host" {
  value = module.db.db_instance_address
}

output "polkadot_db_user" {
  value = postgresql_role.polkadot.name
}
output "polkadot_db_pass" {
  value = random_password.polkadot.result
  sensitive = true
}
output "polkadot_db_host" {
  value = module.db.db_instance_address
}
output "polkadot_db_name" {
  value = postgresql_database.polkadot.name
}

output "squid_polkadot_db_user" {
  value = postgresql_role.squid_polkadot.name
}
output "squid_polkadot_db_pass" {
  value = random_password.squid_polkadot.result
  sensitive = true
}
output "squid_polkadot_db_host" {
  value = module.db.db_instance_address
}
output "squid_polkadot_db_name" {
  value = postgresql_database.squid_polkadot.name
}
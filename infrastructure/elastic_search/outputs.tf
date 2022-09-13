output "endpoint" {
  value = aws_elasticsearch_domain.es.endpoint
}
output "user" {
  value = local.user
}
output "password" {
  value = random_password.admin.result
  sensitive = true
}
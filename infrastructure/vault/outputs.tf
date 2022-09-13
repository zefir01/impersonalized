output "irsa_arn" {
  value = module.irsa.arn
}
output "s3_bucket_name" {
  value = local.s3_bucket_name
}
output "kms_key_id" {
  value = aws_kms_key.vault.id
}
output "sa_name" {
  value = local.sa_name
}
output "sa_namespace" {
  value = local.sa_namespace
}
output "table_name" {
  value = local.table_name
}
output "amp_url" {
  value = aws_prometheus_workspace.this.prometheus_endpoint
}
output "prometheus_irsa_arn" {
  value = module.irsa.arn
}

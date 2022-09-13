output "main_domain" {
  value = data.aws_route53_zone.zone[0].name
}
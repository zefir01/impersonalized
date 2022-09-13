data "aws_route53_zone" "zone" {
  count        = length(var.zones)
  name         = "${var.zones[count.index]}."
  private_zone = false
}

module "acm_blablablaapis" {
  count   = length(data.aws_route53_zone.zone)
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name = data.aws_route53_zone.zone[count.index].name
  zone_id     = data.aws_route53_zone.zone[count.index].id

  subject_alternative_names = [
    "*.${data.aws_route53_zone.zone[count.index].name}",
  ]

  wait_for_validation = true

  tags = {
    Environment = terraform.workspace
  }
}
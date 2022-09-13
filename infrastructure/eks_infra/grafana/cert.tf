data "aws_route53_zone" "selected" {
  name         = "${var.domain}."
  private_zone = false
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.4.0"

  domain_name = "${var.service_name}.${var.stack}.${var.domain}"
  zone_id     = data.aws_route53_zone.selected.id

  wait_for_validation = true

  tags = {
    Environment = terraform.workspace
  }
}

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.45.0"
      configuration_aliases = [ aws.us-east-1 ]
    }
  }
}

data "aws_route53_zone" "zone" {
  name         = "${var.domain}."
  private_zone = false
}

module "acm_wildcard" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  providers = {
    aws = aws.us-east-1
  }

  domain_name = "${var.subdomain}.${var.domain}"
  zone_id     = data.aws_route53_zone.zone.id

  wait_for_validation = true

  tags = {
    Environment = terraform.workspace
  }
}
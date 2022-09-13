provider "aws" {
  alias  = "aws"
  region = "eu-central-1"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

module "frontend" {
  source        = "./cf_distribution"
  subdomain     = "app"
  domain        = var.app_domain
  target_domain = "frontend.${var.domain}"
  #target_domain = "echoserver.blablablaapis.codes"
  name          = "frontend"
  providers     = {
    aws           = aws.aws
    aws.us-east-1 = aws.us-east-1
  }
}

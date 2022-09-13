resource "aws_security_group" "ep_sg" {
  vpc_id = module.vpc.vpc_id
  tags   = local.default-tags
}

resource "aws_security_group_rule" "default_rule_ingress" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.ep_sg.id
  to_port           = 0
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "default_rule_egress" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.ep_sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

data "aws_availability_zones" "zones" {}

module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  name                   = var.stack
  azs                    = local.azs
  cidr                   = "10.0.0.0/16"
  private_subnets        = ["10.0.0.0/18", "10.0.64.0/18"]
  public_subnets         = ["10.0.128.0/18", "10.0.192.0/18"]
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = merge(tomap({
    "kubernetes.io/cluster/${var.cluster_name}" = "shared",
    "kubernetes.io/role/elb"                    = "1"
    "type"                                      = "public"
    "stack"                                     = var.stack
  }),
    local.default-tags
  )
  private_subnet_tags = merge(tomap({
    "kubernetes.io/cluster/${var.cluster_name}" = "shared",
    "kubernetes.io/role/internal-elb"           = "1"
    "type"                                      = "private"
    "stack"                                     = var.stack
  }),
    local.default-tags
  )
  create_database_subnet_group           = true
  database_subnets                       = ["10.0.3.0/24", "10.0.4.0/24"]
  create_database_subnet_route_table     = var.public_db_subnets
  create_database_internet_gateway_route = var.public_db_subnets

  tags = local.default-tags
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "3.0.0"
  count   = local.enable_endpoints

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [aws_security_group.ep_sg.id]
  tags               = local.default-tags

  endpoints = {
    s3 = {
      service = "s3"
      tags    = { Name = "s3-vpc-endpoint" }
    },
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    lambda = {
      service             = "lambda"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    ecs = {
      service             = "ecs"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    ecs_telemetry = {
      service             = "ecs-telemetry"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    ec2 = {
      service             = "ec2"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      //policy              = data.aws_iam_policy_document.generic_endpoint_policy.json
    },
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      //policy              = data.aws_iam_policy_document.generic_endpoint_policy.json
    },
    kms = {
      service             = "kms"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    codedeploy = {
      service             = "codedeploy"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    codedeploy_commands_secure = {
      service             = "codedeploy-commands-secure"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    logs = {
      service             = "logs"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    sts = {
      service             = "sts"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    elasticloadbalancing = {
      service             = "elasticloadbalancing"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    autoscaling = {
      service             = "autoscaling"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    },
    appmesh-envoy-management = {
      service             = "appmesh-envoy-management"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
    }
  }
}

data "aws_iam_policy_document" "generic_endpoint_policy" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}
resource "random_password" "admin" {
  length           = 16
  special          = true
  number           = true
  override_special = "!#%&*()-_+[]{}<>:?"
  min_special      = 1
  min_numeric      = 1
  min_lower        = 1
  min_upper        = 1
}

locals {
  user = "admin"
}

resource "aws_kms_key" "elasticsearch_kms_key" {
  description = "KMS key to encrypt the Elasticsearch volume"

  # Tags
  tags = merge(var.tags, {
    Name = "elasticsearch-kms"
  })

}

resource "aws_kms_alias" "key" {
  name          = "alias/elasticsearch-kms"
  target_key_id = aws_kms_key.elasticsearch_kms_key.key_id
}

resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
  description      = "Allows Amazon ES to manage AWS resources for a domain on your behalf."
}

resource "aws_security_group" "es_sg" {
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "default_rule_ingress" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.es_sg.id
  to_port           = 0
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "default_rule_egress" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.es_sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_elasticsearch_domain" "es" {
  depends_on            = [aws_iam_service_linked_role.es]
  domain_name           = var.stack
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type            = "t3.small.elasticsearch"
    instance_count           = 1
    dedicated_master_enabled = "false"
    dedicated_master_count   = "0"
    zone_awareness_enabled   = "false"
  }

  vpc_options {
    subnet_ids = [var.subnet]
    security_group_ids = [aws_security_group.es_sg.id]
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = local.user
      master_user_password = random_password.admin.result
    }
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled    = "true"
    kms_key_id = aws_kms_alias.key.target_key_arn
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = 10
  }

  tags = var.tags
}
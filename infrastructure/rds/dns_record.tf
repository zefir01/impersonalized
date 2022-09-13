#resource "kubernetes_secret" "blablabla-db" {
#  metadata {
#    name      = "postgres-db"
#    namespace = "blablabla"
#  }
#
#  data = {
#    db_name  = local.db_name
#    username = local.username
#    password = module.db.db_instance_password
#    db_url   = "postgresql://${local.username}:${module.db.db_instance_password}@${local.db_service}:${local.db_service_port}/${local.db_name}?schema=public"
#  }
#}
#
#resource "kubernetes_service" "blablabla-db" {
#  metadata {
#    name      = local.db_service
#    namespace = "blablabla"
#  }
#
#  spec {
#    type          = "ExternalName"
#    external_name = module.db.db_instance_address
#    port {
#      port        = local.db_service_port
#      target_port = module.db.db_instance_port
#    }
#  }
#}

data "aws_route53_zone" "selected" {
  count   = var.publicly_accessible? 1 : 0
  name         = "${var.domain}."
  private_zone = false
}

resource "aws_route53_record" "db" {
  count   = var.publicly_accessible? 1 : 0
  zone_id = data.aws_route53_zone.selected[0].id
  name    = "db-${var.stack}.${data.aws_route53_zone.selected[0].name}"
  type    = "CNAME"
  ttl     = "300"

  records = [module.db.db_instance_address]
}
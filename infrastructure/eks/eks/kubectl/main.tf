#module "kubeconfig" {
#  source  = "./kubeconfig"
#
#  current_context = var.cluster_name
#  clusters        = [
#    {
#      "name" : var.cluster_arn,
#      "server" : var.cluster_host,
#      certificate_authority_data = base64encode(var.cluster_ca)
#    }
#  ]
#  contexts = [
#    {
#      "name" : var.cluster_name,
#      "cluster_name" : var.cluster_arn
#      "user" : var.cluster_arn
#    }
#  ]
#  users = [
#    {
#      "name" : var.cluster_arn
#      "token" : var.cluster_token
#    }
#  ]
#}


resource "null_resource" "kubectl" {
  depends_on = [null_resource.kubeconfig]
  provisioner "local-exec" {
    command     = "kubectl ${var.command}"
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command     = "aws eks update-kubeconfig --region ${var.region} --name ${var.cluster_name}"
    interpreter = ["/bin/bash", "-c"]
  }
}
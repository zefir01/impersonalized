resource "random_string" "uid" {
  length  = 12
  upper   = false
  lower   = true
  number  = false
  special = false
}

locals {
  default-tags = merge(
    var.tags,
    local.eks-owned-tag
  )
}

## kubernetes tags
locals {
  eks-owned-tag = {
    format("kubernetes.io/cluster/%s", var.stack) = "owned"
  }
}

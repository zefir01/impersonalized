locals {
  eks-tag = {
    "eks:cluster-name" = var.cluster_name
  }
  default-tags = merge(
    { "terraform" = true },
    var.tags
  )
}

locals {
  enable_endpoints = var.enable_endpoints?1 : 0
}

locals {
  azs = [sort(data.aws_availability_zones.zones.names)[0], sort(data.aws_availability_zones.zones.names)[1]]
}
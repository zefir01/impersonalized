module "eks" {
  source = "./terraform-aws-eks"

  cluster_name    = var.stack
  cluster_version = var.kubernetes_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cluster_enabled_log_types       = var.enabled_cluster_log_types

  cluster_addons = {
    kube-proxy = {
      version           = "v1.22.6-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      version           = "v1.10.2-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id                               = var.vpc_id
  subnet_ids                           = var.subnets
  #https://github.com/aws/karpenter/issues/1165
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    ingress_allow_karpenter_webhook_access_from_control_plane = {
      description                   = "Allow access from control plane to webhook port of karpenter"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  cluster_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    ingress_nodes_karpenter_ports_tcp = {
      description                = "Karpenter readiness"
      protocol                   = "-1"
      from_port                  = 0
      to_port                    = 0
      type                       = "ingress"
      source_node_security_group = true
    }
  }

  eks_managed_node_groups = {
    main = {
      disk_size      = 30
      instance_types = [var.main_instance_type]
      min_size       = var.main_instance_count
      max_size       = var.main_instance_count
      desired_size   = var.main_instance_count
      capacity_type  = "ON_DEMAND"
      #iam_role_additional_policies = concat(["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"], var.policy_arns)
    }
  }

  tags = var.tags

  partition            = var.partition
  partition_dns_suffix = var.partition_dns_suffix
  region               = var.region
  account_id           = var.account_id

  manage_aws_auth_configmap = true
  #  create_aws_auth_configmap = true
  aws_auth_roles            = [
    {
      rolearn  = var.github_role_arn
      username = "github-actions"
      groups   = ["system:masters"]
    },
  ]

}

resource "aws_eks_addon" "coredns" {
  depends_on        = [module.eks]
  cluster_name      = var.stack
  addon_name        = "coredns"
  addon_version     = "v1.8.7-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_addon" "aws-ebs-csi-driver" {
  depends_on        = [module.eks]
  cluster_name      = var.stack
  addon_name        = "aws-ebs-csi-driver"
  addon_version     = "v1.5.2-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
}

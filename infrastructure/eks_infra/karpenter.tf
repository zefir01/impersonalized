#data "aws_iam_policy" "ssm_managed_instance" {
#  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#}

resource "aws_iam_policy" "karpenter_controller" {
  name_prefix = "prometheus"
  policy      = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameter",
          "iam:PassRole",
          "ec2:RunInstances",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeAvailabilityZones",
          "ec2:DeleteLaunchTemplate",
          "ec2:CreateTags",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:DescribeSpotPriceHistory",
          "pricing:GetProducts",
          "ec2:TerminateInstances",
          "pricing:GetProducts",
          "ec2:DescribeSpotPriceHistory"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

module "irsa_karpenter" {
  source         = "../irsa"
  name           = "karpenter"
  cluster_name   = var.cluster_name
  namespace      = "karpenter"
  serviceaccount = "karpenter"
  oidc_url       = var.oidc_url
  oidc_arn       = var.oidc_arn
  policy_arns    = [aws_iam_policy.karpenter_controller.arn, aws_iam_policy.spot.arn]
  tags           = var.tags
}


resource "aws_iam_policy" "spot" {
  name_prefix = "karpenter"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCreationOfServiceLinkedRoleForSpot",
            "Effect": "Allow",
            "Action": ["iam:CreateServiceLinkedRole"],
            "Resource": "*",
	    "Condition": {
	         "StringLike":{
			"iam:AWSServiceName": "spot.amazonaws.com"
		  }
 	    }
        }
    ]
}
EOF
}

#resource "aws_iam_role_policy_attachment" "karpenter_ssm_policy" {
#  role       = var.cluster_worker_iam_role_name
#  policy_arn = data.aws_iam_policy.ssm_managed_instance.arn
#}

resource "aws_iam_instance_profile" "karpenter" {
  name = "KarpenterNodeInstanceProfile-${var.cluster_name}"
  role = var.cluster_worker_iam_role_name
}

resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = "v0.13.2"

  dynamic "set" {
    for_each = {
      "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.irsa_karpenter.arn
      "clusterName"                                               = var.cluster_name
      "clusterEndpoint"                                           = var.cluster_endpoint
      "aws.defaultInstanceProfile"                                = aws_iam_instance_profile.karpenter.name
      "logLevel"                                                  = "debug"
      "replicas"                                                  = var.replicas
      "webhook.resources.requests.cpu"                            = "10m"
      "controller.resources.requests.cpu"                         = "10m"
      "controller.resources.requests.memory"                      = "128Mi"
      "controller.resources.limits.memory"                        = "256Mi"
      "controller.resources.limits.cpu"                           = "50m"
    }
    content {
      name  = set.key
      value = set.value
    }
  }

  set {
    name  = "controller.env[0].name"
    value = "AWS_ENI_LIMITED_POD_DENSITY"
  }

  set {
    name  = "controller.env[0].value"
    value = "false"
    type  = "string"
  }
}

module "path_hash" {
  source = "github.com/claranet/terraform-path-hash?ref=v1.0.0"
  path   = "${path.module}/charts/provisioners"
}
/*
resource "helm_release" "provisioners" {
  depends_on       = [helm_release.karpenter]
  name             = "provisioners"
  version          = null
  chart            = "${path.module}/charts/provisioners"
  namespace        = "karpenter"
  create_namespace = false
  cleanup_on_fail  = true

  dynamic "set" {
    for_each = {
      "clusterName"       = var.cluster_name
      "instanceType"      = var.karpenter_instance_type
      "hash"              = module.path_hash.result
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}
*/
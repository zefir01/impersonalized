local k8s = import '../../libs/k8s.libsonnet';
local _aws_auth = import 'aws_auth.libsonnet';
local _cni = import 'cni.libsonnet';
local _eip = import 'eip.libsonnet';
local _eks = import 'eks.libsonnet';
local _eks_addon = import 'eks_addon.libsonnet';
local _eks_ng = import 'eks_ng.libsonnet';
local _helm_pc = import 'helm_provider_config.libsonnet';
local _policy = import 'iam_policy.libsonnet';
local _role = import 'iam_role.libsonnet';
local _attach = import 'iam_role_policy_attachement.libsonnet';
local _igw = import 'igw.libsonnet';
local _k8s_pc = import 'k8s_provider_config.libsonnet';
local _nat_gw = import 'nat_gw.libsonnet';
local _object = import 'object.libsonnet';
local _rt = import 'route_table.libsonnet';
local _sg = import 'sg.libsonnet';
local _subnets = import 'subnets.libsonnet';
local _vpc = import 'vpc.libsonnet';
local _xr_test = import 'xr_test.jsonnet';

function(
  provider_config='aws-provider',
  stack='test1',
  region='eu-central-1',
  vpc_cidr='10.0.0.0/16',
  public_subnets_cidr=['10.0.1.0/24', '10.0.2.0/24'],
  private_subnets_cidr=['10.0.3.0/24', '10.0.4.0/24'],
  admin_arn='arn:aws:iam::111111111111:user/petr@blablabla.network',
  create_provider='k8s-new'
)
  {
    local vpc = _vpc(provider_config, stack, region, vpc_cidr),
    local private_subnets = _subnets(vpc, true, private_subnets_cidr, stack),
    local public_subnets = _subnets(vpc, false, public_subnets_cidr, stack),
    local igw = _igw(vpc, stack),
    local public_rt = _rt(vpc, igw, public_subnets, stack, 'public'),
    local eip = _eip(vpc, stack),
    local nat_gw = _nat_gw(vpc, public_subnets[0], eip, stack),
    local private_rt = _rt(vpc, nat_gw, private_subnets, stack, 'private'),
    local cloudwatch_policy = _policy('cloudwatch', '', stack, |||
      {
         "Statement": [
             {
                 "Action": [
                     "logs:CreateLogGroup"
                 ],
                 "Effect": "Deny",
                 "Resource": "arn:aws:logs:eu-central-1:111111111111:log-group:/aws/eks/main/cluster"
             }
         ],
         "Version": "2012-10-17"
         }
    |||),
    local eks_role = _role(provider_config, 'eks', '', stack, |||
      {
          "Version": "2012-10-17",
          "Statement": [
              {
                  "Sid": "EKSClusterAssumeRole",
                  "Effect": "Allow",
                  "Principal": {
                      "Service": "eks.amazonaws.com"
                  },
                  "Action": "sts:AssumeRole"
              }
          ]
      }
    |||),
    local attach1 = _attach(provider_config, 'attach1', stack, eks_role, policy=cloudwatch_policy),
    local attach2 = _attach(provider_config, 'attach2', stack, eks_role, policyArn='arn:aws:iam::aws:policy/AmazonEKSClusterPolicy'),
    local attach3 = _attach(provider_config, 'attach3', stack, eks_role, policyArn='arn:aws:iam::aws:policy/AmazonEKSVPCResourceController'),

    local ng_sg = _sg(provider_config, 'eks-ng-sg', stack, region, vpc, 'EKS NodeGroup sg', ingress_all=true, egress_all=true),

    local eks = _eks(
      vpc,
      private_subnets,
      stack,
      {
        namespace: 'default',
        name: 'eks-connection',
      },
      eks_role,
      sgs=[ng_sg]
    ),
    local k8s_provider_config = _k8s_pc(create_provider, 'default', 'eks-connection', 'kubeconfig'),
    local cni_items = _cni(region).items,
    local objects = [
      _object(create_provider, 'cni-deploy' + i, stack, cni_items[i])
      for i in std.range(0, std.length(cni_items) - 1)
    ],
    local ng = _eks_ng(provider_config, 'ng1', stack, region, eks, private_subnets),
    local auth = _aws_auth(admin_arn, stack, create_provider),

    local helm_provider_config = _helm_pc(create_provider, 'default', 'eks-connection', 'kubeconfig'),


    local deploy = _object(create_provider, 'test-deploy', stack, k8s.deployment('test-deploy',
                                                                                 [
                                                                                   k8s.deployment_container('gcr.io/google_containers/echoserver:1.4', 'echoserver', ports=[
                                                                                     k8s.deployment_container_port('http', 8080, 'TCP'),
                                                                                   ],),
                                                                                 ],
                                                                                 namespace='default')),
    local service = _object(create_provider,
                            'test-service',
                            stack,
                            k8s.service('test-service',
                                        { app: 'test-deploy' },
                                        [
                                          k8s.service_port('http', 80, 'http'),
                                        ],
                                        type='NodePort',
                                        namespace='default')),
    local ingress = _object(create_provider,
                            'test-ingress',
                            stack,
                            k8s.alb_ingress(
                              'echo-' + stack,
                              'echo-' + stack,
                              [
                                stack + '.blablablaapis.codes',
                              ],
                              [
                                k8s.alb_ingress_rule(stack + '.blablablaapis.codes',
                                                     [k8s.alb_ingress_rule_path('/', 'test-service', 80)]),
                              ],
                              is_internal=false,
                              external_dns=true,
                              namespace='default'
                            )),


    apiVersion: 'v1',
    kind: 'List',
    items: private_subnets + public_subnets + [
             vpc,
             igw,
             public_rt,
             eip,
             nat_gw,
             private_rt,
             cloudwatch_policy,
             eks_role,
             attach1,
             attach2,
             attach3,

             eks,
             _eks_addon(provider_config, region, eks, 'kube-proxy', 'v1.22.6-eksbuild.1'),
             _eks_addon(provider_config, region, eks, 'vpc-cni', 'v1.11.0-eksbuild.1'),
             _eks_addon(provider_config, region, eks, 'coredns', 'v1.8.7-eksbuild.1'),
             _eks_addon(provider_config, region, eks, 'aws-ebs-csi-driver', 'v1.5.2-eksbuild.1'),
             k8s_provider_config,
             ng_sg,
             auth,
             deploy,
             service,
             ingress,
           ]
           + _xr_test().items
           + objects
           + ng.items,
  }

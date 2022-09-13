local irsa_arn = std.extVar('aws_irsa_role_arn');

local argo = import '../libs/argo.libsonnet';
local k8s = import '../libs/k8s.libsonnet';
local cp = import '../libs/crossplane.libsonnet';

local e = import '../libs/env.libsonnet';
local env = e.getEnv();

local var = function(name, value) {
  name: name,
  value: value,
};


[
  argo.app_helm(
    'crossplane-system',
    'crossplane-system',
    'https://charts.crossplane.io/stable',
    'crossplane',
    '1.8.0',
    wave=1,
    ignoreDifferences=[
      {
        group: '*',
        kind: 'ClusterRole',
        jsonPointers: ['/rules'],
      },
    ],
    helm_params=[
      var('resurcesCrossplane.requests.cpu', '30m'),
      var('resourcesCrossplane.requests.memory', '100Mi'),
    ],
  ),
  cp.controller_config('aws-config', irsa_arn, 2000, wave=2),
  cp.provider('provider-aws', 'crossplane/provider-aws:v0.27.0', 'aws-config', wave=3),

  //cp.provider('provider-kubernetes', 'crossplane/provider-kubernetes:v0.3.0', wave=3),
  //cp.provider('provider-helm', 'crossplane/provider-helm:v0.10.0', wave=3),


  cp.provider('provider-kubernetes', env.crossplane_k8s_provider.image, wave=3),
  cp.provider('provider-helm', env.crossplane_helm_provider.image, wave=3),
  k8s.cluster_role(
    'k8s-provider-extended',
    [
      {
        apiGroups: ['*'],
        resources: ['*'],
        verbs: ['*'],
      },
      {
        nonResourceURLs: ['*'],
        verbs: ['*'],
      },
    ],
    {
      'rbac.crossplane.io/aggregate-to-allowed-provider-permissions': 'true',
    },
    wave=1
  ),
  cp.k8s_provider_config('default', wave=4),
  cp.aws_provider_config('aws-provider', wave=4),
  cp.aws_provider_config('default', wave=4),

]

local stack = std.extVar('stack');


local argo = import '../libs/argo.libsonnet';
local k8s = import '../libs/k8s.libsonnet';
local istio = import '../libs/istio.libsonnet';

local e = import '../libs/env.libsonnet';
local env = e.getEnv();

local var = function(name, value) {
  name: name,
  value: std.toString(value),
};


[
  k8s.ns('blablabla1', true, wave=10),

  k8s.deployment(
    'frontend-' + stack,
    [
      k8s.deployment_container(
        env.blablabla1_frontend.image,
        'frontend',
        [k8s.deployment_container_port('http', 3000, 'TCP')],
        k8s.deployment_container_tcp_probe('http'),
        k8s.deployment_container_tcp_probe('http'),
        resources=k8s.deployment_container_resources('10m', '128Mi', '300m', '256Mi')
      ),
    ],
    wave=20
  ),

  k8s.service(
    'frontend-' + stack,
    { app: 'frontend-' + stack },
    [k8s.service_port('http', 80, 'http')],
    wave=20
  ),

  istio.virtualService(
    'frontend',
    [istio.virtualServiceRule(['/'], 'frontend-' + stack, 80)],
    [env.blablabla1_frontend.domain],
    wave=20
  ),
]

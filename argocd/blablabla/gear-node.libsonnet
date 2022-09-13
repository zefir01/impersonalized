local stack = std.extVar('stack');

local k8s = import '../libs/k8s.libsonnet';

local e = import '../libs/env.libsonnet';
local env = e.getEnv();

[
  k8s.deployment(
    'gear-node-' + stack, [
      k8s.deployment_container(
        env.gear_node.image,
        'gear-node',
        [
          k8s.deployment_container_port('prometheus', 9615, 'TCP'),
          k8s.deployment_container_port('p2p', 9944, 'TCP'),
          k8s.deployment_container_port('rpc', 9945, 'TCP'),
          k8s.deployment_container_port('ws', 9946, 'TCP'),
        ],
        k8s.deployment_container_http_probe('prometheus', '/metrics'),
        k8s.deployment_container_http_probe('prometheus', '/metrics'),
        command=['/usr/local/bin/gear-node'],
        args=[
          '--unsafe-ws-external',
          '--unsafe-rpc-external',
          '--prometheus-external',
          '--dev',
          '--base-path',
          '/root/db',
          '--port',
          '9944',
          '--rpc-port',
          '9945',
          '--ws-port',
          '9946',
        ]
      ),
    ]
  ),

  k8s.service(
    'gear-node-' + stack,
    { app: 'gear-node-' + stack },
    [
      k8s.service_port('p2p', 9944, 'p2p'),
      k8s.service_port('rpc', 9945, 'rpc'),
      k8s.service_port('ws', 9946, 'ws'),
    ],
    type='NodePort',
    external_dns=true,
    annotations={
      'service.beta.kubernetes.io/aws-load-balancer-type': 'external',
      'service.beta.kubernetes.io/aws-load-balancer-nlb-target-type': 'ip',
      'service.beta.kubernetes.io/aws-load-balancer-scheme': 'internet-facing',
      'external-dns.alpha.kubernetes.io/hostname': env.gear_node.domain,
    }
  ),

]

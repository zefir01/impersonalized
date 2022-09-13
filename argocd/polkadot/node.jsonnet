local k8s = import '../libs/k8s.libsonnet';
local stack = std.extVar('stack');
local istio = import '../libs/istio.libsonnet';
local e = import '../libs/env.libsonnet';
local env = e.getEnv();

local sync = false;

[
  k8s.ns('polkadot', true, wave=10),

  k8s.storageClass('polkadot-' + stack),
  k8s.pvClaim('polkadot-' + stack, 'polkadot-' + stack, '1000Gi'),

  k8s.deployment(
    'polkadot-node-' + stack,
    [
      k8s.deployment_container(
        'parity/polkadot:v0.9.26',
        'polkadot-node',
        [
          k8s.deployment_container_port('rpc', 9933, 'TCP'),
          k8s.deployment_container_port('ws', 9944, 'TCP'),
          k8s.deployment_container_port('metrics', 9090, 'TCP'),
          k8s.deployment_container_port('p2p', 9922, 'TCP'),
        ],
        k8s.deployment_container_tcp_probe('metrics', initialDelay=180),
        k8s.deployment_container_tcp_probe('metrics'),
        args=[
          '--rpc-port',
          '9933',
          '--rpc-external',
          '--pruning',
          'archive',
          '--base-path',
          '/app/db',
          '--ws-port',
          '9944',
          '--unsafe-ws-external',
          '--chain',
          'polkadot',
          '--prometheus-external',
          '--prometheus-port',
          '9090',
          '--port',
          '9922',
          '--rpc-cors=all',
          //          '--keep-blocks',
          //          '216000',
          //          '--pruning',
          //          '216000',
          //          '--sync',
          //          'fast',
        ],
        volumeMounts=[
          {
            mountPath: '/app/db',
            name: 'polkadot-db',
          },
        ],

        resources=if sync then k8s.deployment_container_resources('1', '512Mi', '2', '2Gi') else k8s.deployment_container_resources('100m', '512Mi', '1', '2Gi')
      ),
    ],
    volumes=[
      {
        name: 'polkadot-db',
        persistentVolumeClaim: {
          claimName: 'polkadot-' + stack,
        },
      },
    ],
    strategy='Recreate',
    tolerations=if sync then [
      {
        key: 'payload',
        value: 'true',
      },
    ] else null,
    wave=20,
  ),

  k8s.service(
    'polkadot-node-' + stack,
    { app: 'polkadot-node-' + stack },
    [
      k8s.service_port('ws', 80, 'ws'),
    ],
    wave=20
  ),
]

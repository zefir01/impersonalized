local k8s = import '../libs/k8s.libsonnet';
local stack = std.extVar('stack');
local istio = import '../libs/istio.libsonnet';
local e = import '../libs/env.libsonnet';
local env = e.getEnv();

local polkadot_db_user = std.extVar('polkadot_db_user');
local polkadot_db_pass = std.extVar('polkadot_db_pass');
local polkadot_db_host = std.extVar('polkadot_db_host');
local polkadot_db_name = std.extVar('polkadot_db_name');

local var = function(name, value) {
  name: name,
  value: std.toString(value),
};

local sync = false;

[
  k8s.deployment(
    'substrate-ingest-' + stack,
    [
      k8s.deployment_container(
        'subsquid/substrate-ingest:firesquid',
        'substrate-ingest',
        [k8s.deployment_container_port('prom', 9090, 'TCP')],
        k8s.deployment_container_tcp_probe('prom', initialDelay=180),
        k8s.deployment_container_tcp_probe('prom'),
        resources=k8s.deployment_container_resources('256m', '128Mi', '1', '256Mi'),
        args=[
          '-e',
          'ws://polkadot-node-' + stack + ':80',
          '-c',
          '50',
          '--out',
          'postgres://' + polkadot_db_user + ':' + polkadot_db_pass + '@' + polkadot_db_host + ':5432/' + polkadot_db_name,
          '--prom-port',
          '9090',
          '--write-batch-size',
          '30',
          '--start-block',
          '10879370',
        ],
      ),
    ],
    tolerations=if sync then [
      {
        key: 'payload',
        value: 'true',
      },
    ] else null,
    wave=20,
  ),

  k8s.deployment(
    'substrate-gateway-' + stack,
    [
      k8s.deployment_container(
        'subsquid/substrate-gateway:firesquid',
        'substrate-gateway',
        [k8s.deployment_container_port('http', 8000, 'TCP')],
        k8s.deployment_container_http_probe('http', path='/metrics', initialDelay=60),
        k8s.deployment_container_http_probe('http', path='/metrics'),
        env=[
          var('DATABASE_MAX_CONNECTIONS', 1),
          var('RUST_LOG', 'actix_web=info,actix_server=info'),
        ],
        resources=k8s.deployment_container_resources('100m', '64Mi', '200m', '256Mi'),
        args=[
          '--database-url',
          'postgres://' + polkadot_db_user + ':' + polkadot_db_pass + '@' + polkadot_db_host + ':5432/' + polkadot_db_name,
        ],
      ),
    ],
    tolerations=if sync then [
      {
        key: 'payload',
        value: 'true',
      },
    ] else null,
    wave=20,
  ),
  k8s.service(
    'substrate-gateway-' + stack,
    { app: 'substrate-gateway-' + stack },
    [
      k8s.service_port('http', 80, 'http'),
    ],
    wave=20
  ),

  istio.telemetry('polkadot'),
]

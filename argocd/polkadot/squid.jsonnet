local argo = import '../libs/argo.libsonnet';
local istio = import '../libs/istio.libsonnet';
local k8s = import '../libs/k8s.libsonnet';

local e = import '../libs/env.libsonnet';
local env = e.getEnv();

local squid_polkadot_db_user = std.extVar('squid_polkadot_db_user');
local squid_polkadot_db_pass = std.extVar('squid_polkadot_db_pass');
local squid_polkadot_db_host = std.extVar('squid_polkadot_db_host');
local squid_polkadot_db_name = std.extVar('squid_polkadot_db_name');

local var = function(name, value) {
  name: name,
  value: std.toString(value),
};

[
  k8s.deployment(
    'squid-polkadot-processor',
    [
      k8s.deployment_container(
        env.squid_processor.image,
        'squid-processor',
        [k8s.deployment_container_port('prometheus', 9090, 'TCP')],
        k8s.deployment_container_http_probe('prometheus', path='/metrics', initialDelay=180),
        k8s.deployment_container_http_probe('prometheus', path='/metrics'),
        env=[
          var('ARCHIVE_URL', 'http://substrate-gateway-main/graphql'),
          var('BATCH_SIZE', 100),
          var('DB_HOST', squid_polkadot_db_host),
          var('DB_NAME', squid_polkadot_db_name),
          var('DB_PASS', squid_polkadot_db_pass),
          var('DB_PORT', 5432),
          var('DB_USER', squid_polkadot_db_user),
          var('NODE_WS', 'ws://polkadot-node-main'),
          var('PROMETHEUS_PORT', 9090),
          var('START_BLOCK', 11270865),
          var('WALLETS_JSON', env.squid_processor.wallets),
          var('CHAIN', 'polkadot'),
        ],
        resources=k8s.deployment_container_resources('10m', '256Mi', '500m', '512Mi')
      ),
    ],
    wave=20,
  ),

  k8s.deployment(
    'squid-polkadot-query',
    [
      k8s.deployment_container(
        env.squid_query.image,
        'squid-query',
        [k8s.deployment_container_port('graphql', 4000, 'TCP')],
        k8s.deployment_container_tcp_probe('graphql', initialDelay=180),
        k8s.deployment_container_tcp_probe('graphql'),
        env=[
          var('DB_HOST', squid_polkadot_db_host),
          var('DB_NAME', squid_polkadot_db_name),
          var('DB_PASS', squid_polkadot_db_pass),
          var('DB_PORT', 5432),
          var('DB_USER', squid_polkadot_db_user),
        ],
        resources=k8s.deployment_container_resources('10m', '256Mi', '500m', '512Mi')
      ),
    ],
    wave=20,
  ),

  k8s.service(
    'squid-polkadot-query',
    { app: 'squid-polkadot-query' },
    [
      k8s.service_port('graphql', 80, 'graphql'),
    ],
    wave=20
  ),
]
+
e.toDev(
  istio.virtualService(
    'squid-polkadot-query',
    [istio.virtualServiceRule(['/'], 'squid-polkadot-query', 80)],
    [env.squid_query.domain],
    wave=20
  ),
)

local cm = import '../libs/cert-manager.libsonnet';
local cp = import '../libs/crossplane.libsonnet';
local e = import '../libs/env.libsonnet';
local istio = import '../libs/istio.libsonnet';
local prom = import '../libs/prometheus.libsonnet';
local xray = import './xray.libsonnet';

local env = e.getEnv();

local account_id = std.extVar('account_id');
local amp_url = std.extVar('amp_url');

[
  prom.serviceMonitor(
    'istiod',
    { app: 'istiod' },
    'http-monitoring',
    relabelings=[
      {
        sourceLabels: ['__meta_kubernetes_service_name', '__meta_kubernetes_endpoint_port_name'],
        action: 'keep',
        regex: 'istiod;http-monitoring',
      },
    ],
    metricRelabelings=[
      {
        sourceLabels: ['__name__'],
        action: 'keep',
        regex: 'istio_requests_total',
      },
      {
        sourceLabels: ['namespace'],
        action: 'keep',
        regex: 'blablabla',
      },
    ],
    namespaceSelector=['istio-system'],
  ),
  prom.podMonitor(
    'envoy-stats',
    { 'security.istio.io/tlsMode': 'istio' },
    'http-envoy-prom',
    path='/stats/prometheus',
    relabelings=[
      {
        sourceLabels: ['__meta_kubernetes_pod_container_port_name'],
        action: 'keep',
        regex: '.*-envoy-prom',
      },
    ],
    metricRelabelings=[
      {
        sourceLabels: ['__name__'],
        action: 'keep',
        regex: 'istio_requests_total',
      },
      {
        sourceLabels: ['namespace'],
        action: 'keep',
        regex: 'blablabla',
      },
    ],
  ),
  cm.selfSignedClusterIssuer(wave=20),
  istio.ingress(env.domains, '32766', wave=10),
]
+ istio.gws('main', env.domains, 'istio-system', wave=30)
+ xray('istio-system', wave=30)

+ e.toDev(
  cp.claim(
    'argoeks',
    'argoeks',
    'blablabla.org',
    params={
      region: 'eu-central-1',
      clusterName: 'main',
      awsProviderConfig: 'aws-provider',
      environment: 'dev',
      accountId: account_id,
      ampUrl: amp_url,
    }
  )
)

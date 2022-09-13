local argo = import '../libs/argo.libsonnet';
local cm = import '../libs/cert-manager.libsonnet';
local istio = import '../libs/istio.libsonnet';
local k8s = import '../libs/k8s.libsonnet';
local prom = import '../libs/prometheus.libsonnet';
local rancher = import 'rancher.libsonnet';
local cm = import '../libs/cert-manager.libsonnet';
local k = import '../libs/karpenter.libsonnet';

local crossplane_irsa_arn = std.extVar('crossplane_irsa_arn');
local prometheus_irsa_arn = std.extVar('prometheus_irsa_arn');
local account_id = std.extVar('account_id');
local amp_url = std.extVar('amp_url');
local region = std.extVar('region');
local cluster_name = std.extVar('cluster_name');

local polkadot_db_user = std.extVar('polkadot_db_user');
local polkadot_db_pass = std.extVar('polkadot_db_pass');
local polkadot_db_host = std.extVar('polkadot_db_host');
local polkadot_db_name = std.extVar('polkadot_db_name');

local squid_polkadot_db_user = std.extVar('squid_polkadot_db_user');
local squid_polkadot_db_pass = std.extVar('squid_polkadot_db_pass');
local squid_polkadot_db_host = std.extVar('squid_polkadot_db_host');
local squid_polkadot_db_name = std.extVar('squid_polkadot_db_name');

local grafana_irsa_arn = std.extVar('grafana_irsa_arn');

local blablabla_db_url = std.extVar('blablabla_db_url');

local e = import '../libs/env.libsonnet';
local env = e.getEnv();

[

  argo.app(
    'misc',
    'misc',
    'git@github.com:blablabla/argocd',
    'misc',
    wave=20,
    skipDryRun=true,
    ignoreDifferences=[
      {
        group: 'blablabla.org/v1beta1',
        kind: 'Argoeks',
      },
    ],
    vars=[
      argo.var('account_id', account_id),
      argo.var('amp_url', amp_url),
    ],
  ),

  argo.app('blablabla',
           'blablabla',
           'git@github.com:blablabla/argocd',
           'blablabla',
           vars=[
             argo.var('stack', 'main'),
             argo.var('blablabla_db_url', blablabla_db_url),
           ],
           wave=20),

  argo.app('polkadot',
           'polkadot',
           'git@github.com:blablabla/argocd',
           'polkadot',
           vars=[
             argo.var('stack', 'main'),
             argo.var('polkadot_db_user', polkadot_db_user),
             argo.var('polkadot_db_pass', polkadot_db_pass),
             argo.var('polkadot_db_host', polkadot_db_host),
             argo.var('polkadot_db_name', polkadot_db_name),

             argo.var('squid_polkadot_db_user', squid_polkadot_db_user),
             argo.var('squid_polkadot_db_pass', squid_polkadot_db_pass),
             argo.var('squid_polkadot_db_host', squid_polkadot_db_host),
             argo.var('squid_polkadot_db_name', squid_polkadot_db_name),
           ],
           wave=20),

  argo.app('metabase-app',
           'metabase',
           'git@github.com:blablabla/argocd',
           'metabase',
           vars=[
             argo.extVar('metabase_user'),
             argo.extVar('metabase_password'),
             argo.extVar('metabase_db'),
             argo.extVar('metabase_db_host'),
           ],
           wave=20),

  argo.app('blablabla1',
           'blablabla1',
           'git@github.com:blablabla/argocd',
           'blablabla1',
           vars=[
             argo.var('stack', 'main'),
           ],
           wave=20),

  argo.app_helm(
    'metrics-server',
    'kube-system',
    'https://kubernetes-sigs.github.io/metrics-server/',
    'metrics-server',
    '3.8.2',
    helm_params=[
      argo.var('replicas', '1'),
      argo.var('metrics.enabled', 'true'),
      argo.var('serviceMonitor.enabled', 'true'),
    ],
    wave=10
  ),

  k8s.ns('istio-ingress', istio=true, wave=30),

  argo.app_helm(
    'istio-base',
    'istio-system',
    'https://istio-release.storage.googleapis.com/charts',
    'base',
    '1.13.3',
    ignoreDifferences=[
      {
        group: 'admissionregistration.k8s.io',
        kind: 'ValidatingWebhookConfiguration',
        name: 'istiod-default-validator',
        jqPathExpressions: [
          '.webhooks[0].failurePolicy',
        ],
      },
    ],
    selfHeal=false,
    wave=20
  ),
  argo.app_helm(
    'istio-istiod',
    'istio-system',
    'https://istio-release.storage.googleapis.com/charts',
    'istiod',
    '1.13.3',
    helm_params=[
      argo.var('pilot.resources.requests.cpu', '30m'),
      argo.var('pilot.resources.requests.memory', '128Mi'),
      argo.var('global.tracer.zipkin.address', 'zipkin.istio-system.svc:9411'),
      argo.var('pilot.traceSampling', '1'),
      argo.var('meshConfig.enableTracing', 'true'),
      argo.var('meshConfig.defaultConfig.tracing.sampling', '1'),
      //argo.var('sidecarInjectorWebhook.rewriteAppHTTPProbe', 'false'),
      argo.var('global.proxy.resources.requests.cpu', '10m'),
      argo.var('global.proxy.resources.requests.memory', '128Mi'),
      argo.var('global.proxy.resources.limits.cpu', '30m'),
      argo.var('global.proxy.resources.limits.memory', '128Mi'),
    ],
    selfHeal=false,
    wave=20,
    ignoreDifferences=[
      {
        group: 'admissionregistration.k8s.io',
        kind: 'MutatingWebhookConfiguration',
        name: 'istio-sidecar-injector',
        jqPathExpressions: [
          '.webhooks[0].clientConfig.caBundle',
          '.webhooks[1].clientConfig.caBundle',
          '.webhooks[2].clientConfig.caBundle',
          '.webhooks[3].clientConfig.caBundle',
          '.webhooks[4].clientConfig.caBundle',
          '.webhooks[5].clientConfig.caBundle',
          '.webhooks[6].clientConfig.caBundle',
          '.webhooks[7].clientConfig.caBundle',
          '.webhooks[8].clientConfig.caBundle',
          '.webhooks[9].clientConfig.caBundle',
        ],
      },
    ],
  ),
  argo.app_helm(
    'istio-gateway',
    'istio-ingress',
    'https://istio-release.storage.googleapis.com/charts',
    'gateway',
    '1.13.3',
    createNamespace=false,
    selfHeal=false,
    helm_params=[
      argo.var('service.type', 'NodePort'),
      argo.var('service.ports[0].nodePort', '32766'),
      argo.var('service.ports[0].port', '15021'),
      argo.var('service.ports[0].name', 'status-port'),
      argo.var('service.ports[0].protocol', 'TCP'),
      argo.var('service.ports[0].targetPort', '15021'),
      argo.var('service.ports[1].name', 'http2'),
      argo.var('service.ports[1].port', '80'),
      argo.var('service.ports[1].protocol', 'TCP'),
      argo.var('service.ports[1].targetPort', '80'),
      argo.var('service.ports[2].name', 'https'),
      argo.var('service.ports[2].port', '443'),
      argo.var('service.ports[2].protocol', 'TCP'),
      argo.var('service.ports[2].targetPort', '443'),

      argo.var('resources.requests.cpu', '30m'),
      argo.var('resources.requests.memory', '128Mi'),

    ],
    wave=30,
    replace=true,
  ),


  argo.app_helm(
    'cert-manager',
    'cert-manager',
    'https://charts.jetstack.io',
    'cert-manager',
    '1.8.0',
    helm_params=[
      argo.var('installCRDs', 'true'),
    ],
    wave=10
  ),


  //argo.app('test-payload', 'test-payload', 'git@github.com:blablabla/argocd', 'test-payload', wave=30),


  argo.app_helm(
    'grafana-operator',
    'grafana-operator',
    'https://charts.bitnami.com/bitnami',
    'grafana-operator',
    '2.5.4',
    helm_params=[
      argo.var('operator.scanAllNamespaces', 'true'),
      argo.var('operator.prometheus.serviceMonitor.enabled', 'false'),
      argo.var('grafana.enabled', 'false'),
      argo.var('operator.watchNamespace', 'grafana'),
    ],
    wave=10
  ),
  argo.app(
    'grafana',
    'grafana',
    'git@github.com:blablabla/argocd',
    'grafana',
    wave=20,
    vars=[
      argo.var('grafana_irsa_arn', grafana_irsa_arn),
      argo.var('amp_url', amp_url),
      argo.var('region', region),
      argo.var('grafana_domain', env.grafana.domain),
    ]
  ),

]
+ e.toDev(
  argo.app(
    'crossplane-base',
    'crossplane-system',
    'git@github.com:blablabla/argocd',
    'crossplane',
    vars=[
      argo.var('aws_irsa_role_arn', crossplane_irsa_arn),
    ],
    wave=10,
    skipDryRun=true
  ),
)

+ e.toDev(
  argo.app(
    'compositions',
    'compositions',
    'git@github.com:blablabla/argocd',
    'compositions',
    wave=20,
    vars=[
      argo.var('domain', 'blablabla.org'),
    ]
  ),
)

+ e.toProd(
  argo.appKustomize('prometheus-operator-crds',
                    'prometheus',
                    'git@github.com:blablabla/argocd',
                    'apps/prometheus-crds',
                    replace=true,
                    applyOutOfSyncOnly=true,
                    wave=10),
)

+ e.toProd(
  argo.app_helm(
    'prometheus-operator',
    'prometheus',
    'https://prometheus-community.github.io/helm-charts',
    'kube-prometheus-stack',
    '35.0.3',
    wave=20,
    helm_params=[
      argo.var('kubeApiServer.enabled', 'false'),
      argo.var('prometheus.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn', prometheus_irsa_arn),
      argo.var('prometheus.serviceAccount.name', 'prometheus-server'),
      argo.var('grafana.enabled', 'false'),
      argo.var('alertmanager.enabled', 'false'),
      argo.var('prometheus.prometheusSpec.remoteWrite[0].url', amp_url + 'api/v1/remote_write'),
      argo.var('prometheus.prometheusSpec.remoteWrite[0].sigv4.region', region),
      argo.var('prometheus.prometheusSpec.remoteWrite[0].writeRelabelConfigs[0].targetLabel', 'cluster_name'),
      argo.var('prometheus.prometheusSpec.remoteWrite[0].writeRelabelConfigs[0].replacement', cluster_name),
      argo.var('prometheus.prometheusSpec.retention', '3h'),

      argo.var('prometheus.prometheusSpec.resources.requests.cpu', '10m'),
      argo.var('prometheus.prometheusSpec.resources.requests.memory', '128Mi'),

      argo.var('prometheusOperator.prometheusConfigReloader.resources.requests.cpu', '10m'),
      //argo.var("prometheusOperator.prometheusConfigReloader.resources.requests.memory", "128Mi"),

      argo.var('prometheusOperator.admissionWebhooks.patch.resources.requests.cpu', '10m'),
      argo.var('prometheusOperator.admissionWebhooks.patch.resources.requests.memory', '128Mi'),

      argo.var('prometheusOperator.resources.requests.cpu', '10m'),
      argo.var('prometheusOperator.resources.requests.memory', '128Mi'),

      argo.var('prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues', 'false'),
      argo.var('prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues', 'false'),
    ],
    skipCrds=true,
    selfHeal=false,
    ignoreDifferences=[
      {
        group: 'admissionregistration.k8s.io',
        kind: 'MutatingWebhookConfiguration',
        name: 'prometheus-operator-kube-p-admission',
        jqPathExpressions: [
          '.webhooks[0].failurePolicy',
        ],
      },
      {
        group: 'admissionregistration.k8s.io',
        kind: 'ValidatingWebhookConfiguration',
        name: 'prometheus-operator-kube-p-admission',
        jqPathExpressions: [
          '.webhooks[0].failurePolicy',
        ],
      },
    ],
  ),
)
+ e.toDev(
  k.provisioner('default', 'payload', 'true', cluster_name)
)

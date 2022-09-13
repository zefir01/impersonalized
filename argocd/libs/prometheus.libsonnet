//https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/user-guides/getting-started.md#include-servicemonitors
{
  local _serviceMonitor = function(
    name,
    selector,
    port,
    namespaceSelector=null,
    path='/metrics',
    interval='15s',
    relabelings=null,
    metricRelabelings=null,
    wave=null
                         ) {

    apiVersion: 'monitoring.coreos.com/v1',
    kind: 'ServiceMonitor',
    metadata: {
      name: name,
      namespace: 'prometheus',
      annotations: {
        'argocd.argoproj.io/sync-options': 'SkipDryRunOnMissingResource=true',
        [if wave != null then 'annotations']: {
          'argocd.argoproj.io/sync-wave': std.toString(wave),
        },
      },
    },
    spec: {
      selector: {
        matchLabels: selector,
      },
      namespaceSelector: if namespaceSelector == null then { any: true } else {
        matchNames: namespaceSelector,
      },
      jobLabel: name,
      endpoints: [
        {
          port: port,
          interval: interval,
          path: path,
          [if relabelings != null then 'relabelings']: relabelings,
          [if metricRelabelings != null then 'metricRelabelings']: metricRelabelings,
        },
      ],
    },
  },
  serviceMonitor:: _serviceMonitor,

  local _podMonitor = function(
    name,
    selector,
    port,
    namespaceSelector=null,
    path='/metrics',
    interval='15s',
    relabelings=null,
    metricRelabelings=null,
    wave=null
                     ) {
    apiVersion: 'monitoring.coreos.com/v1',
    kind: 'PodMonitor',
    metadata: {
      name: name,
      namespace: 'prometheus',
      annotations: {
        'argocd.argoproj.io/sync-options': 'SkipDryRunOnMissingResource=true',
        [if wave != null then 'annotations']: {
          'argocd.argoproj.io/sync-wave': std.toString(wave),
        },
      },
    },
    spec: {
      jobLabel: name,
      selector: {
        matchLabels: selector,
      },
      namespaceSelector: if namespaceSelector == null then { any: true } else {
        matchNames: namespaceSelector,
      },
      podMetricsEndpoints: [
        {
          port: port,
          interval: interval,
          path: path,
          [if relabelings != null then 'relabelings']: relabelings,
          [if metricRelabelings != null then 'metricRelabelings']: metricRelabelings,
        },
      ],
    },
  },
  podMonitor:: _podMonitor,
}

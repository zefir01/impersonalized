local env = import 'env.libsonnet';
local k8s = import 'k8s.libsonnet';

{
  local _app(
    name,
    dest_namespace,
    git,
    path,
    project='default',
    vars=null,
    dest_k8s='https://kubernetes.default.svc',
    namespace='argo',
    annotations={},
    wave=null,
    createNamespace=true,
    replace=false,
    applyOutOfSyncOnly=false,
    skipDryRun=false,
    skipCrds=null,
    helm_params=null,
    ignoreDifferences=null,
    targetRevision='main'
  ) = {

    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: std.prune(
      {
        name: name,
        namespace: namespace,
        finalizers: [
          'resources-finalizer.argocd.argoproj.io',
        ],
        annotations: annotations + if wave != null then { 'argocd.argoproj.io/sync-wave': std.toString(wave) } else {},
      }
    ),
    spec: {
      project: project,
      source: {
        repoURL: git,
        targetRevision: targetRevision,
        path: path,
        [if helm_params != null || skipCrds != null then 'helm']: {
          [if helm_params != null then 'parameters']: helm_params,
          [if skipCrds != null then 'skipCrds']: skipCrds,
        },
      } + {
        directory: {
          jsonnet: {
            extVars: [env.envVar()] + if vars != null then vars else [],
          },
        },
      },
      destination: {
        server: dest_k8s,
        namespace: dest_namespace,
      },
      syncPolicy: {
        automated: {
          prune: true,
          selfHeal: true,
        },
        syncOptions: [
                       'CreateNamespace=' + createNamespace,
                     ]
                     + if replace then ['Replace=true'] else []
                                                             + if applyOutOfSyncOnly then ['ApplyOutOfSyncOnly=true'] else []
                                                                                                                           + if skipDryRun then ['SkipDryRunOnMissingResource=true'] else [],
        retry: {
          limit: -1,
          backoff: {
            duration: '5s',
            factor: 2,
            maxDuration: '3m',
          },
        },
      },
      [if ignoreDifferences != null then 'ignoreDifferences']: ignoreDifferences,
    },
  },
  app:: _app,

  local _appKustomize(
    name,
    dest_namespace,
    git,
    path,
    project='default',
    dest_k8s='https://kubernetes.default.svc',
    namespace='argo',
    annotations={},
    wave=null,
    createNamespace=true,
    replace=false,
    applyOutOfSyncOnly=false,
    skipDryRun=false,
    skipCrds=null,
    helm_params=null,
    ignoreDifferences=null,
    targetRevision='main'
  ) = {

    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: std.prune(
      {
        name: name,
        namespace: namespace,
        finalizers: [
          'resources-finalizer.argocd.argoproj.io',
        ],
        annotations: annotations + if wave != null then { 'argocd.argoproj.io/sync-wave': std.toString(wave) } else {},
      }
    ),
    spec: {
      project: project,
      source: {
        repoURL: git,
        targetRevision: targetRevision,
        path: path,
        [if helm_params != null || skipCrds != null then 'helm']: {
          [if helm_params != null then 'parameters']: helm_params,
          [if skipCrds != null then 'skipCrds']: skipCrds,
        },
      },
      destination: {
        server: dest_k8s,
        namespace: dest_namespace,
      },
      syncPolicy: {
        automated: {
          prune: true,
          selfHeal: true,
        },
        syncOptions: [
                       'CreateNamespace=' + createNamespace,
                     ]
                     + if replace then ['Replace=true'] else []
                                                             + if applyOutOfSyncOnly then ['ApplyOutOfSyncOnly=true'] else []
                                                                                                                           + if skipDryRun then ['SkipDryRunOnMissingResource=true'] else [],
        retry: {
          limit: -1,
          backoff: {
            duration: '5s',
            factor: 2,
            maxDuration: '3m',
          },
        },
      },
      [if ignoreDifferences != null then 'ignoreDifferences']: ignoreDifferences,
    },
  },
  appKustomize:: _appKustomize,

  local _app_helm(name,
                  dest_namespace,
                  repo,
                  chart,
                  targetRevision,
                  helm_params=null,
                  project='default',
                  dest_k8s='https://kubernetes.default.svc',
                  namespace='argo',
                  annotations={},
                  wave=null,
                  selfHeal=true,
                  ignoreDifferences=null,
                  createNamespace=true,
                  skipCrds=null,
                  skipDryRun=false,
                  replace=false) = {

    apiVersion: 'argoproj.io/v1alpha1',
    kind: 'Application',
    metadata: std.prune(
      {
        name: name,
        namespace: namespace,
        finalizers: [
          'resources-finalizer.argocd.argoproj.io',
        ],
        annotations: annotations + if wave != null then { 'argocd.argoproj.io/sync-wave': std.toString(wave) } else {},
      }
    ),
    spec: {
      project: project,
      source: {
        repoURL: repo,
        targetRevision: targetRevision,
        chart: chart,
        [if helm_params != null || skipCrds != null then 'helm']: {
          [if helm_params != null then 'parameters']: helm_params,
          [if skipCrds != null then 'skipCrds']: skipCrds,
        },
      },
      destination: {
        server: dest_k8s,
        namespace: dest_namespace,
      },
      syncPolicy: {
        automated: {
          prune: true,
          selfHeal: selfHeal,
        },
        syncOptions: [
                       'CreateNamespace=' + createNamespace,
                     ]
                     + if skipDryRun then ['SkipDryRunOnMissingResource=true'] else []
                                                                                    + if replace then ['Replace=true'] else [],
        retry: {
          limit: -1,
          backoff: {
            duration: '5s',
            factor: 2,
            maxDuration: '3m',
          },
        },
      },
      [if ignoreDifferences != null then 'ignoreDifferences']: ignoreDifferences,
    },
  },
  app_helm:: _app_helm,


  local parseKubeconfig = function(region, name, configStr) {
    local parsed = std.parseYaml(configStr),

    config: {
      bearerToken: parsed.users[0].user.token,
      tlsClientConfig: {
        caData: parsed.clusters[0].cluster['certificate-authority-data'],
        insecure: false,
      },
    },

    server: parsed.clusters[0].cluster.server,
    name: parsed.users[0].name,
    clusterName: 'eks-' + region + '-' + name,
  },

  local _clusterFromKubeconfig = function(region, name, configStr, environment, wave=null) k8s.secret(
    environment + '-' + parseKubeconfig(region, name, configStr).clusterName,
    stringData={
      name: environment + '-' + parseKubeconfig(region, name, configStr).clusterName,
      server: parseKubeconfig(region, name, configStr).server,
      config: std.toString(parseKubeconfig(region, name, configStr).config),
    },
    wave=wave,
    labels={
      'argocd.argoproj.io/secret-type': 'cluster',
    },
  ),
  clusterFromKubeconfig:: _clusterFromKubeconfig,

  local _var = function(name, value) {
    name: name,
    value: value,
  },
  var:: _var,

  local _extVar = function(name) {
    name: name,
    value: std.extVar(name),
  },
  extVar:: _extVar,
}

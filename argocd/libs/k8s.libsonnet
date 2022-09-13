{
  local _service_port(name, port, target_port, protocol='TCP') = {
    port: port,
    targetPort: target_port,
    protocol: protocol,
    name: name,
  },
  service_port:: _service_port,

  local _service(name,
                 selector,
                 ports,
                 labels={},
                 type='ClusterIP',
                 annotations={},
                 external_dns=false,
                 namespace=null,
                 wave=null) = {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: name,
      [if namespace != null then 'namespace']: namespace,
      labels: { app: name } + labels,
      annotations: {
        'external-dns.kubernetes.io/enable': if external_dns then 'true' else 'false',
        [if wave != null then 'argocd.argoproj.io/sync-wave']: std.toString(wave),
      } + annotations,
    },
    spec: {
      type: type,
      ports: ports,
      selector: selector,
    },
  },
  service:: _service,

  local _alb_ingress_rule_path(path, name, port_number) = {
    path: path,
    backend: {
      service: {
        name: name,
        port: {
          number: port_number,
        },
      },
    },
    pathType: 'Prefix',
  },
  alb_ingress_rule_path:: _alb_ingress_rule_path,

  local _alb_ingress_rule(host, paths) = {
    host: host,
    http: {
      paths: [
        {
          path: '/',
          backend: {
            service: {
              name: 'ssl-redirect',
              port: {
                name: 'use-annotation',
              },
            },
          },
          pathType: 'Prefix',
        },
      ] + paths,
    },
  },
  alb_ingress_rule:: _alb_ingress_rule,

  local _alb_ingress(name,
                     balancer_name,
                     tls_hosts,
                     rules,
                     labels={},
                     is_internal=true,
                     external_dns=false,
                     tags=null,
                     namespace=null,
                     wave=null,
                     backendHttps=false,
                     annotations=null) = {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'Ingress',
    metadata: {
      name: name,
      [if namespace != null then 'namespace']: namespace,
      labels: { app: name } + labels,
      annotations: {
        'alb.ingress.kubernetes.io/scheme': if !is_internal then 'internet-facing' else 'internal',
        'alb.ingress.kubernetes.io/listen-ports': '[{"HTTP": 80}, {"HTTPS":443}]',
        [if tags != null then 'alb.ingress.kubernetes.io/tags']: tags,  //"stack=main, bla bla bla"
        'alb.ingress.kubernetes.io/load-balancer-name': balancer_name,
        'external-dns.kubernetes.io/enable': if external_dns then 'true' else 'false',
        'alb.ingress.kubernetes.io/actions.ssl-redirect': '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}',
        [if wave != null then 'argocd.argoproj.io/sync-wave']: std.toString(wave),
        [if backendHttps then 'alb.ingress.kubernetes.io/backend-protocol']: 'HTTPS',
        'alb.ingress.kubernetes.io/load-balancer-attributes': 'idle_timeout.timeout_seconds=3600',
      } + if annotations != null then annotations else {},
    },
    spec: {
      ingressClassName: 'alb',
      tls: [
        {
          hosts: tls_hosts,
          secretName: name + '-ingress-cert',
        },
      ],
      rules: rules,
    },
  },
  alb_ingress:: _alb_ingress,

  local _deployment_container_port(name, port, protocol) = {
    name: name,
    containerPort: port,
    protocol: protocol,
  },
  deployment_container_port:: _deployment_container_port,

  local _deployment_container_http_probe(port, path='/', initialDelay=null) = {
    httpGet: {
      path: path,
      port: port,
    },
    [if initialDelay != null then 'initialDelaySeconds']: initialDelay,
  },
  deployment_container_http_probe:: _deployment_container_http_probe,

  local _deployment_container_tcp_probe(port, initialDelay=null) = {
    tcpSocket: {
      port: port,
    },
    [if initialDelay != null then 'initialDelaySeconds']: initialDelay,
  },
  deployment_container_tcp_probe:: _deployment_container_tcp_probe,

  local _deployment_container_resources(requests_cpu, requests_memory, limits_cpu, limits_memory) = {
    requests: {
      cpu: requests_cpu,
      memory: requests_memory,
    },
    limits: {
      cpu: limits_cpu,
      memory: limits_memory,
    },
  },
  deployment_container_resources:: _deployment_container_resources,

  local _deployment_container(image,
                              name,
                              ports=null,
                              liveness_probe=null,
                              readiness_probe=null,
                              resources=null,
                              command=null,
                              args=null,
                              env=null,
                              volumeMounts=null) = {
    name: name,
    image: image,
    [if ports != null then 'ports']: ports,
    [if liveness_probe != null then 'livenessProbe']: liveness_probe,
    [if readiness_probe != null then 'readinessProbe']: readiness_probe,
    [if resources != null then 'resources']: resources,
    [if command != null then 'command']: command,
    [if args != null then 'args']: args,
    [if env != null then 'env']: env,
    [if volumeMounts != null then 'volumeMounts']: volumeMounts,
  },
  deployment_container:: _deployment_container,

  local _secret_env(name, secret, key) = {
    name: name,
    valueFrom: {
      secretKeyRef: {
        name: secret,
        key: key,
      },
    },
  },
  secret_env:: _secret_env,

  local _deployment_volume = function(name, configMap=null) {
    name: name,
    [if configMap != null then 'configMap']: {
      name: configMap,
    },
  },
  deployment_volume:: _deployment_volume,

  local _deployment(name, containers, labels={}, replicas=1, namespace=null, wave=null, volumes=null, disableIstioProbes=false, strategy=null, tolerations=null) = {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: name,
      [if namespace != null then 'namespace']: namespace,
      labels: {
        app: name,
      } + labels,
      [if wave != null then 'annotations']: {
        'argocd.argoproj.io/sync-wave': std.toString(wave),
      },
    },
    spec: {
      [if strategy != null then 'strategy']: {
        type: strategy,
      },
      replicas: replicas,
      selector: {
        matchLabels: {
          app: name,
        },
      },
      template: {
        metadata: {
          labels: {
            app: name,
          },
          [if disableIstioProbes then 'annotations']: {
            'sidecar.istio.io/rewriteAppHTTPProbers': 'false',
          },
        },
        spec: {
          containers: containers,
          [if volumes != null then 'volumes']: volumes,
          [if tolerations != null then 'tolerations']: tolerations,
        },
      },
    },
  },
  deployment:: _deployment,

  local _cluster_role(name, rules, labels=null, wave=null) = {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRole',
    metadata: {
      name: name,
      [if labels != null then 'labels']: labels,
      [if wave != null then 'annotations']: {
        'argocd.argoproj.io/sync-wave': std.toString(wave),
      },
    },
    rules: rules,
  },
  cluster_role:: _cluster_role,

  local _secret(name, data=null, stringData=null, labels=null, wave=null, namespace=null) = {
    apiVersion: 'v1',
    kind: 'Secret',
    metadata: {
      name: name,
      [if wave != null then 'annotations']: {
        'argocd.argoproj.io/sync-wave': std.toString(wave),
      },
      [if namespace != null then 'namespace']: namespace,
      [if labels != null then 'labels']: labels,
    },
    type: 'Opaque',
    [if data != null then 'data']: data,
    [if stringData != null then 'stringData']: stringData,
  },
  secret:: _secret,

  local _ns = function(name, istio=false, wave=null) {
    apiVersion: 'v1',
    kind: 'Namespace',
    metadata: {
      name: name,
      [if istio then 'labels']: {
        'istio-injection': 'enabled',
      },
      [if wave != null then 'annotations']: {
        'argocd.argoproj.io/sync-wave': std.toString(wave),
      },
    },
  },
  ns:: _ns,

  local _configMap = function(name, data, namespace=null, wave=null) {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: name,
      [if namespace != null then 'namespace']: namespace,
      [if wave != null then 'annotations']: {
        'argocd.argoproj.io/sync-wave': std.toString(wave),
      },
    },
    data: data,
  },
  configMap:: _configMap,

  local _sa = function(name, namespace=null, irsa_arn=null, wave=null) {
    apiVersion: 'v1',
    kind: 'ServiceAccount',
    metadata: {
      [if irsa_arn != null then 'annotations']: {
        'eks.amazonaws.com/role-arn': irsa_arn,
      },
      name: name,
      [if namespace != null then 'namespace']: namespace,
      [if wave != null then 'annotations']: {
        'argocd.argoproj.io/sync-wave': std.toString(wave),
      },
    },
  },
  sa:: _sa,

  local _role = function(name, rules, namespace=null, wave=null) {
    kind: 'Role',
    apiVersion: 'rbac.authorization.k8s.io/v1',
    metadata: {
      name: name,
      [if namespace != null then 'namespace']: namespace,
      [if wave != null then 'annotations']: {
        'argocd.argoproj.io/sync-wave': std.toString(wave),
      },
    },
    rules: rules,
  },
  role:: _role,

  local _roleBinding = function(name, role, sa, namespace=null, wave=null) {
    kind: 'RoleBinding',
    apiVersion: 'rbac.authorization.k8s.io/v1',
    metadata: {
      name: name,
      [if namespace != null then 'namespace']: namespace,
      [if wave != null then 'annotations']: {
        'argocd.argoproj.io/sync-wave': std.toString(wave),
      },
    },
    roleRef: {
      kind: 'Role',
      name: role,
      apiGroup: 'rbac.authorization.k8s.io',
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: sa,
      },
    ],
  },
  roleBinding:: _roleBinding,

  local _clusterRoleBinding = function(name, role, sa, namespace, wave=null) {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRoleBinding',
    metadata: {
      name: name,
      [if wave != null then 'annotations']: {
        'argocd.argoproj.io/sync-wave': std.toString(wave),
      },
    },
    roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'ClusterRole',
      name: role,
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: sa,
        namespace: namespace,
      },
    ],
  },
  clusterRoleBinding:: _clusterRoleBinding,

  local _storageClass = function(name, reclaimPolicy='Retain') {
    apiVersion: 'storage.k8s.io/v1',
    kind: 'StorageClass',
    metadata: {
      name: name,
    },
    provisioner: 'kubernetes.io/aws-ebs',
    parameters: {
      fsType: 'ext4',
      type: 'gp2',
    },
    reclaimPolicy: reclaimPolicy,
    allowVolumeExpansion: true,
    volumeBindingMode: 'Immediate',
  },
  storageClass:: _storageClass,

  local _pvClaim = function(name, storageClassName, storage, accessModes='ReadWriteOnce') {
    apiVersion: 'v1',
    kind: 'PersistentVolumeClaim',
    metadata: {
      name: name,
    },
    spec: {
      accessModes: [
        accessModes,
      ],
      storageClassName: storageClassName,
      resources: {
        requests: {
          storage: storage,
        },
      },
    },
  },
  pvClaim:: _pvClaim,

  local _pod = function(
    name,
    containers,
    volumes=null,
    namespace=null,
    wave=null,
    labels={}
              ) {
    apiVersion: 'v1',
    kind: 'Pod',
    metadata: {
      name: name,
      [if namespace != null then 'namespace']: namespace,
      labels: {
        app: name,
      } + labels,
      annotations: {
        'argocd.argoproj.io/sync-options': 'Replace=true',
        [if wave != null then 'argocd.argoproj.io/sync-wave']: std.toString(wave),
      },
    },
    spec: {
      [if volumes != null then 'volumes']: volumes,
      containers: containers,
    },
  },
  pod:: _pod,
}

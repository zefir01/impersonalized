local cm = import '../libs/cert-manager.libsonnet';
local k8s = import '../libs/k8s.libsonnet';

{
  local _ingress = function(domains, healthcheckPort, tls=true, wave=null) k8s.alb_ingress(
    'gw-ingress',
    'gw-ingress',
    domains,
    [
      k8s.alb_ingress_rule(d,
                           [k8s.alb_ingress_rule_path('/', 'istio-gateway', if tls then 443 else 80)])
      for d in domains
    ],
    is_internal=false,
    external_dns=true,
    namespace='istio-ingress',
    backendHttps=true,
    annotations={
      'alb.ingress.kubernetes.io/healthcheck-protocol': 'HTTP',  //--HTTPS by default
      'alb.ingress.kubernetes.io/healthcheck-port': healthcheckPort,  //--traffic-port by default
      'alb.ingress.kubernetes.io/healthcheck-path': '/healthz/ready',  //--/ by default/
      'alb.ingress.kubernetes.io/load-balancer-attributes': 'idle_timeout.timeout_seconds=3600',
    },
    wave=wave
  ),
  ingress:: _ingress,

  local _gws = function(name, hosts, namespace, wave=null) [
    {
      apiVersion: 'networking.istio.io/v1alpha3',
      kind: 'Gateway',
      metadata: {
        name: name,
        namespace: namespace,
        [if wave != null then 'annotations']: {
          'argocd.argoproj.io/sync-wave': std.toString(wave),
        },
      },
      spec: {
        selector: {
          istio: 'gateway',
        },
        servers: [
          {
            port: {
              number: 443,
              name: 'https',
              protocol: 'HTTPS',
            },
            tls: {
              mode: 'SIMPLE',
              credentialName: namespace + '-ingress-' + name + '-tls',
            },
            //hosts: [namespace+"/*"],
            hosts: ['*'],
            //hosts: hosts
          },
        ],
      },
    },

    cm.cert(namespace + '-ingress-' + name + '-tls',
            namespace + '-ingress-' + name + '-tls',
            hosts[0],
            dnsNames=hosts,
            namespace='istio-ingress',
            wave=wave),
  ],
  gws:: _gws,

  local _virtualServiceRule = function(prefixes, host, port) {
    match: [
      {
        uri: {
          prefix: prefix,
        },
      }
      for prefix in prefixes
    ],
    route: [
      {
        destination: {
          host: host,
          port: {
            number: port,
          },
        },
      },
    ],
  },
  virtualServiceRule:: _virtualServiceRule,

  local _virtualService = function(name, rules, hosts, namespace=null, wave=null) {
    apiVersion: 'networking.istio.io/v1alpha3',
    kind: 'VirtualService',
    metadata: {
      name: name,
      [if namespace != null then 'namespace']: namespace,
      [if wave != null then 'annotations']: {
        'argocd.argoproj.io/sync-wave': std.toString(wave),
      },
    },
    spec: {
      hosts: hosts,
      gateways: ['istio-system/main'],
      http: rules,
    },
  },
  virtualService:: _virtualService,

  local _gw = function(name, hosts, namespace, wave=null) {
    apiVersion: 'networking.istio.io/v1alpha3',
    kind: 'Gateway',
    metadata: {
      name: name,
      namespace: namespace,
      [if wave != null then 'annotations']: {
        'argocd.argoproj.io/sync-wave': std.toString(wave),
      },
    },
    spec: {
      selector: {
        istio: 'gateway',
      },
      servers: [
        {
          port: {
            number: 80,
            name: 'http',
            protocol: 'HTTP',
          },
          hosts: hosts,
        },
      ],
    },
  },
  gw:: _gw,

  local _telemetry = function(namespace) {
    apiVersion: 'telemetry.istio.io/v1alpha1',
    kind: 'Telemetry',
    metadata: {
      name: 'stdout',
      namespace: namespace,
    },
    spec: {
      accessLogging: [
        {
          providers: [
            {
              name: 'envoy',
            },
          ],
        },
      ],
    },
  },
  telemetry:: _telemetry,
}

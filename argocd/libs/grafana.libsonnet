{
  local _dataSource = function(name, url, region, namespace=null, wave=null) {
    apiVersion: 'integreatly.org/v1alpha1',
    kind: 'GrafanaDataSource',
    metadata: {
      name: name,
      [if namespace != null then 'namespace']: namespace,
      [if wave != null then 'annotations']: {
        'argocd.argoproj.io/sync-wave': std.toString(wave),
      },
    },
    spec: {
      name: name + '.yaml',
      datasources: [
        {
          name: name,
          type: 'prometheus',
          access: 'server',
          url: url,
          isDefault: true,
          version: 1,
          editable: true,
          jsonData: {
            tlsSkipVerify: true,
            timeInterval: '5s',
            sigV4Auth: true,
            sigV4Region: region,
            sigV4AuthType: 'default',
          },
        },
      ],
    },
  },
  dataSource:: _dataSource,

  local _authGoogle = function(domains, client_id, client_secret) {
    allow_sign_up: true,
    allowed_domains: std.join(' ', domains),
    auth_url: 'https://accounts.google.com/o/oauth2/auth',
    client_id: client_id,
    client_secret: client_secret,
    enabled: true,
    scopes: 'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email',
    token_url: 'https://oauth2.googleapis.com/token',
  },
  authGoogle:: _authGoogle,

  local _grafana = function(name, domain, irsa_arn=null, namespace=null, wave=null, auth=null) {
    apiVersion: 'integreatly.org/v1alpha1',
    kind: 'Grafana',
    metadata: {
      name: name,
      [if namespace != null then 'namespace']: namespace,
      [if wave != null then 'annotations']: {
        'argocd.argoproj.io/sync-wave': std.toString(wave),
      },
    },
    spec: {
      serviceAccount: {
        [if irsa_arn != null then 'annotations']: {
          'eks.amazonaws.com/role-arn': irsa_arn,
        },
      },
      client: {
        preferService: true,
      },
      ingress: {
        enabled: false,
        pathType: 'Prefix',
        path: '/',
      },
      config: {
        server: {
          root_url: 'https://' + domain + '/',
        },
        log: {
          mode: 'console',
          level: 'error',
        },
        'log.frontend': {
          enabled: true,
        },
        auth: {
          sigv4_auth_enabled: true,
        },
        'auth.anonymous': {
          enabled: false,
        },
        [if auth != null then 'auth.google']: auth,
      },
      service: {
        name: name,
        type: 'ClusterIP',
      },
      dashboardLabelSelector: [
        {
          matchExpressions: [
            {
              key: 'app',
              operator: 'In',
              values: [
                'grafana',
              ],
            },
          ],
        },
      ],
      resources: {
        limits: {
          cpu: '200m',
          memory: '512Mi',
        },
        requests: {
          cpu: '30m',
          memory: '128Mi',
        },
      },
    },
  },
  grafana:: _grafana,

  local _dashboard = function(name, json, namespace=null, wave=null) {
    apiVersion: 'integreatly.org/v1alpha1',
    kind: 'GrafanaDashboard',
    metadata: {
      name: name,
      labels: {
        app: 'grafana',
      },
      [if namespace != null then 'namespace']: namespace,
      [if wave != null then 'annotations']: {
        'argocd.argoproj.io/sync-wave': std.toString(wave),
      },
    },
    spec: {
      json: json,
    },
  },
  dashboard:: _dashboard,
}

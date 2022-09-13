local e = import '../libs/env.libsonnet';
local k8s = import '../libs/k8s.libsonnet';
local env = e.getEnv();

function(namespace, wave=null) [
  k8s.configMap('otelcol-custom-config',
                {
                  'config.yaml': |||
                    receivers:
                      zipkin: {}
                    processors: {}
                    exporters:
                      awsxray:
                        traceid_cache_endpoint: local://
                        traceid_cache_ttl_seconds: 5
                      logging:
                        loglevel: info
                    service:
                      pipelines:
                        traces:
                          receivers:
                            - zipkin
                          processors: []
                          exporters:
                            - awsxray
                  |||,
                },
                namespace=namespace,
                wave=wave),

  k8s.deployment(
    'otelcol-custom',
    [
      k8s.deployment_container(
        env.otelcol_custom_istio_awsxray.image,
        'otelcol-custom',
        [k8s.deployment_container_port('zipkin', 9411, 'TCP')],
        k8s.deployment_container_tcp_probe('zipkin'),
        args=[
          '--config',
          '/config/config.yaml',
        ],
        resources=k8s.deployment_container_resources('10m', '128Mi', '100m', '256Mi'),
        volumeMounts=[{
          name: 'otelcol-custom-config',
          mountPath: '/config',
        }],
      ),
    ],
    namespace=namespace,
    wave=wave,
    volumes=[k8s.deployment_volume('otelcol-custom-config', 'otelcol-custom-config')]
  ),

  k8s.service(
    'zipkin',
    { app: 'otelcol-custom' },
    [k8s.service_port('zipkin', 9411, 'zipkin')],
    namespace=namespace,
    wave=wave
  ),
]

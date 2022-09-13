local stack = std.extVar('stack');


local argo = import '../libs/argo.libsonnet';
local k8s = import '../libs/k8s.libsonnet';
local istio = import '../libs/istio.libsonnet';

local e = import '../libs/env.libsonnet';
local env = e.getEnv();

local var = function(name, value) {
  name: name,
  value: std.toString(value),
};

local db_url = std.extVar('blablabla_db_url');


[
  k8s.ns('blablabla', true, wave=10),

  k8s.deployment(
    'backend-' + stack,
    [
      k8s.deployment_container(
        env.blablabla_api.image,
        'backend',
        [k8s.deployment_container_port('http', 3000, 'TCP')],
        k8s.deployment_container_http_probe('http', path='/system/liveness', initialDelay=180),
        k8s.deployment_container_http_probe('http', path='/system/readiness'),
        env=[
          var('SERVICE_URL', env.blablabla_api.domain),
          var('NODE_ENV', 'development'),
          var('PORT', 3000),
          var('KYC_REDIRECT_URL', 'https://' + env.blablabla_api.cloudfront_domain + '/profile?kyc=success'),
          var('KYC_CLIENT_ID', env.blablabla_api.kyc_client_id),
          var('KYC_SECRET_KEY', env.blablabla_api.kyc_secret_key),
          var('POSTMARK_TOKEN', ''),
          var('JWT_SECRET', ''),
          var('DATABASE_URL', db_url),
          var('FRONTEND_URL', env.blablabla_api.cloudfront_domain),
          var('GOOGLE_ANALYTICS_ID', env.blablabla_api.google_analitics_id),
          var('POSTMARK_FROM', env.blablabla_api.postmark_from),
          var('GETRESPONSE_TOKEN', ''),
          var('GLEAM_CAMPAIGN_KEY', ''),
        ],
        resources=k8s.deployment_container_resources('10m', '256Mi', '500m', '512Mi')
      ),
    ],
    wave=20,
  ),

  k8s.service(
    'backend-' + stack,
    { app: 'backend-' + stack },
    [k8s.service_port('http', 80, 'http')],
    wave=20
  ),

  k8s.deployment(
    'frontend-' + stack,
    [
      k8s.deployment_container(
        env.blablabla_app.image,
        'frontend',
        [k8s.deployment_container_port('http', 8080, 'TCP')],
        k8s.deployment_container_tcp_probe('http'),
        k8s.deployment_container_tcp_probe('http'),
        resources=k8s.deployment_container_resources('10m', '128Mi', '300m', '256Mi')
      ),
    ],
    wave=20
  ),

  k8s.service(
    'frontend-' + stack,
    { app: 'frontend-' + stack },
    [k8s.service_port('http', 80, 'http')],
    wave=20
  ),

  istio.virtualService(
    'backend',
    [istio.virtualServiceRule(['/'], 'backend-' + stack, 80)],
    [env.blablabla_api.domain],
    wave=20
  ),

  istio.virtualService(
    'frontend',
    [istio.virtualServiceRule(['/'], 'frontend-' + stack, 80)],
    [env.blablabla_app.domain],
    wave=20
  ),

  istio.telemetry('blablabla'),

]

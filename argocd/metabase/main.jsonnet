local argo = import '../libs/argo.libsonnet';
local istio = import '../libs/istio.libsonnet';

local metabase_user = std.extVar('metabase_user');
local metabase_password = std.extVar('metabase_password');
local metabase_db = std.extVar('metabase_db');
local metabase_db_host = std.extVar('metabase_db_host');

local e = import '../libs/env.libsonnet';
local env = e.getEnv();

local var = function(name, value) {
  name: name,
  value: value,
};

[
  argo.app_helm(
    'metabase',
    'metabase',
    'https://pmint93.github.io/helm-charts',
    'metabase',
    '2.1.2',
    helm_params=[
      var('image.tag', 'v0.43.2'),
      var('database.type', 'postgres'),
      var('database.host', metabase_db_host),
      var('database.port', '5432'),
      var('database.dbname', metabase_db),
      var('database.username', metabase_user),
      var('database.password', metabase_password),
    ],
    wave=10
  ),

  istio.virtualService(
    'metabase',
    [istio.virtualServiceRule(['/'], 'metabase', 80)],
    [env.metabase.domain],
    wave=20
  ),

]

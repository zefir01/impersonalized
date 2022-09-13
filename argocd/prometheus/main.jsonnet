local cp = import '../libs/crossplane.libsonnet';

local domain = std.extVar('domain');
local amp_url = std.extVar('amp_url');

[
  cp.claim(
    'prometheus',
    'prometheus',
    domain,
    params={
      region: 'eu-central-1',
      clusterName: 'main',
      awsProviderConfig: 'aws-provider',
      ampUrl: amp_url,
      targetNamespace: 'prometheus-test',
    }
  ),
]

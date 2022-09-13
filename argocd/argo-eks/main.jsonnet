local argo = import '../libs/argo.libsonnet';
local cp = import '../libs/crossplane.libsonnet';
local k8s = import '../libs/k8s.libsonnet';


local region = std.extVar('region');
local name = std.extVar('name');
local kubeconfig = std.extVar('kubeconfig');
local endpoint = std.extVar('endpoint');
local clusterCA = std.extVar('clusterCA');
local oidc = std.extVar('oidc');
local secretName = std.extVar('secretName');
local secretNamespce = std.extVar('secretNamespce');

local account_id = std.extVar('account_id');
local amp_url = std.extVar('amp_url');

[
  //argo.clusterFromKubeconfig(region, name, kubeconfig, wave=10),
  argo.app('test-payload', 'test-payload', 'git@github.com:blablabla/argocd', 'test-payload', wave=30, dest_k8s=endpoint),
  cp.claim(
    'prometheus',
    'prometheus',
    'blablabla.org',
    params={
      region: 'eu-central-1',
      awsProviderConfig: 'aws-provider',
      accountId: account_id,
      ampUrl: amp_url,
      targetNamespace: 'test',
      eksOidc: oidc,
      clusterName: name,
      clusterEndpoint: endpoint,
    }
  ),
]

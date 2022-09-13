local argo = import '../../libs/argo.libsonnet';


local region = std.extVar('region');
local name = std.extVar('name');
local kubeconfig = std.extVar('kubeconfig');
local environment = std.extVar('env');

[
  argo.clusterFromKubeconfig(region, name, kubeconfig, environment, wave=10),
]

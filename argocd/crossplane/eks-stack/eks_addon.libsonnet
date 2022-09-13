#kube-proxy
#vpc-cni
function(provider_config, region, cluster, addon_name, version){
    "apiVersion": "eks.aws.crossplane.io/v1alpha1",
    "kind": "Addon",
    "metadata": {
        "name": cluster.metadata.name+"-"+addon_name
    },
    "spec": {
        "forProvider": {
            "addonName": addon_name,
            "clusterNameRef": {
                "name": cluster.metadata.name
            },
            "region": region,
            "resolveConflicts": "OVERWRITE",
            "addonVersion": version
        },
        "providerConfigRef": {
            "name": provider_config
        }
    }
}
function(name, secret_namespace, secret_name, secret_key){
    "apiVersion": "helm.crossplane.io/v1beta1",
    "kind": "ProviderConfig",
    "metadata": {
        "name": name
    },
    "spec": {
        "credentials": {
            "source": "Secret",
            "secretRef": {
                "namespace": secret_namespace,
                "name": secret_name,
                "key": secret_key
            }
        }
    }
}
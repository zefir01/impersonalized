function(name, secret_namespace, secret_name, secret_key){
    "apiVersion": "kubernetes.crossplane.io/v1alpha1",
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
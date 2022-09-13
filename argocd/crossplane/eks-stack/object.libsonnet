function(provider, name, stack, manifest){
    "apiVersion": "kubernetes.crossplane.io/v1alpha1",
    "kind": "Object",
    "metadata": {
        "name": name+"-"+stack
    },
    "spec": {
        "forProvider": {
            "manifest": manifest
        },
        "providerConfigRef": {
            "name": provider
        }
    }
}
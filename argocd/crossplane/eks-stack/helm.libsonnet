function(provider, name, stack, repo, version, namespace, values=null, set=null){
    "apiVersion": "helm.crossplane.io/v1beta1",
    "kind": "Release",
    "metadata": {
        "name": name
    },
    "spec": {
        "forProvider": {
            "chart": {
                "name": stack+"-"+name,
                "repository": repo,
                "version": version
            },
            "namespace": namespace,
            [if values!=null then "values"]: values,
            [if set!=null then "set"]: set
        },
        "providerConfigRef": {
            "name": provider
        }
    }
}
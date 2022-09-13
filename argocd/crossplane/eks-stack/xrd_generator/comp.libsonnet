function(name, xrd, resources){
    apiVersion: "apiextensions.crossplane.io/v1",
    kind: "Composition",
    metadata: {
        name: name,
        labels: {
            "crossplane.io/xrd": xrd.metadata.name
        }
    },
    spec: {
        writeConnectionSecretsToNamespace: "default",
        compositeTypeRef: {
            apiVersion: xrd.spec.group+"/"+xrd.spec.versions[0].name,
            kind: xrd.spec.names.kind
        },
        resources: resources
    }
}
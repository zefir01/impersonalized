function(name, kind, domain, params={}){
    apiVersion: domain+"/v1beta1",
    kind: std.asciiUpper(std.substr(kind, 0, 1))+std.substr(kind, 1, std.length(kind)-1),
    metadata: {
        name: name,
    },
    spec: {
        parameters: params,
        compositionRef: {
            name: kind
        },
        /*
        writeConnectionSecretToRef: {
            namespace: "default",
            name: "crossplane-argocd-cluster-connection"
        },
        */
    }
}
#https://github.com/aws-samples/eks-gitops-crossplane-argocd/blob/main/crossplane-imperative/eks-configuration/composition.yaml
function(name, patches=null){
    name: "eks-"+name,
    base: {
        apiVersion: "eks.aws.crossplane.io/v1beta1",
        kind: "Cluster",
        metadata: {
            annotations:{
                "crossplane.io/external-name": name
            },
        },
        spec: {
            deletionPolicy: "Orphan",
            forProvider: {
    #            region: region,
                resourcesVpcConfig:{}
            },
    #        providerConfigRef: providerConfigRef,
            writeConnectionSecretToRef: {
                namespace: "default",
                name: "eks-"+name+"-connection",
            }
        }
    },
    [if patches!=null then "patches"]: patches,
}
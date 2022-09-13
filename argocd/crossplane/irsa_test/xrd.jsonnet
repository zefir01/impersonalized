local xrd = import "libs/xrd.libsonnet";

xrd("irsa", "blablabla.org", outputs=[
        "eksOidc",
        "eksArn",
        "roleArn",
    ],
    params={
        saNamespace:{
            type: "string",
        },
        saName:{
            type: "string",
        },
        localK8sProviderConfig:{
            type: "string",
            default: "k8s-provider-config"
        },
        policyLabels: {
            type: "object",
        },
    },
)
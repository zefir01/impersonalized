function(stack, name, document, labels, description=null){
    apiVersion: "iam.aws.crossplane.io/v1beta1",
    kind: "Policy",
    metadata: {
        name: stack+"-"+name,
        labels: labels
    },
    spec: {
        forProvider: {
            description: if description==null then stack+"-"+name else description,
            name: stack+"-"+name,
            document: document,
        },
        providerConfigRef: {
            name: "aws-provider"
        },
    }
}
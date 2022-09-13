function(vpc, stack, name="internetgateway"){
    "apiVersion": "ec2.aws.crossplane.io/v1beta1",
    "kind": "InternetGateway",
    "metadata": {
        "name": name
    },
    "spec": {
        "forProvider": {
            "vpcIdRef": {
                "name": vpc.metadata.name
            },
            "tags": [
                {
                    "key": "stack",
                    "value": stack
                },
            ]
        },
        "providerConfigRef": vpc.spec.providerConfigRef
    }
}
function(vpc, stack, name="eip"){
    "apiVersion": "ec2.aws.crossplane.io/v1beta1",
    "kind": "Address",
    "metadata": {
        "name": name
    },
    "spec": {
        "forProvider": {
            "region": vpc.spec.forProvider.region,
            "domain": "vpc",
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
function(vpc, public_subnet, eip, stack, name="natgateway"){
    "apiVersion": "ec2.aws.crossplane.io/v1beta1",
    "kind": "NATGateway",
    "metadata": {
        "name": name
    },
    "spec": {
        "forProvider": {
            "region": vpc.spec.forProvider.region,
            "allocationIdRef":{
                "name": eip.metadata.name
            },
            "subnetIdRef": {
                "name": public_subnet.metadata.name
            },
            "tags": [
                {
                    "key": "Name",
                    "value": stack+"-"+name
                },
                {
                    "key": "stack",
                    "value": stack
                },
            ]
        },
        "providerConfigRef": vpc.spec.providerConfigRef
    }
}
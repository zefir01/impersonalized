function(vpc, gw, subnets, stack, name="route-table"){
    "apiVersion": "ec2.aws.crossplane.io/v1beta1",
    "kind": "RouteTable",
    "metadata": {
        "name": stack+"-"+name
    },
    "spec": {
        "forProvider": {
            "region": vpc.spec.forProvider.region,
            "vpcIdRef": {
                "name": vpc.metadata.name
            },
            "routes": [
                {
                    "destinationCidrBlock": "0.0.0.0/0",
                    [if gw.kind=="InternetGateway" then "gatewayIdRef"]: {
                        "name": gw.metadata.name
                    },
                    [if gw.kind=="NATGateway" then "natGatewayIdRef"]: {
                        "name": gw.metadata.name
                    }
                }
            ],
            "associations": [
                {
                    "subnetIdRef": {
                        "name": net.metadata.name
                    }
                } for net in subnets
            ],
            "tags": [
                {
                    "key": "Name",
                    "value": stack+"-"+name
                },
                {
                    "key": "stack",
                    "value": stack
                }
            ]
        },
        "providerConfigRef": vpc.spec.providerConfigRef
    }
}
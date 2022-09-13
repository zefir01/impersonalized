function(provider_config, name, stack, region, vpc, description=name+"-"+stack, ingress=[], egress=[], ingress_all=false, egress_all=false){
    local all={
        "fromPort": null,
        "toPort": null,
        "ipProtocol": "-1",
        "ipRanges": [
            {
                "cidrIp": "0.0.0.0/0"
            }
        ]
    },

    "apiVersion": "ec2.aws.crossplane.io/v1beta1",
    "kind": "SecurityGroup",
    "metadata": {
        "name": name+"-"+stack
    },
    "spec": {
        "forProvider": {
            description: description,
            "groupName": name+"-"+stack,
            "region": region,
            "vpcIdRef": {
                name: vpc.metadata.name
            },
            ingress: ingress + if ingress_all then [all] else [],
            egress: egress + if egress_all then [all] else [],
        },
        "providerConfigRef": {
            name: provider_config
        }
    }
}
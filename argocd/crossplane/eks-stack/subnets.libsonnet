local azs=["a","b", "c"];

function(vpc, is_private, cidrs, cluster=null)[
    {
        local this=self,
        type:: if is_private then "private" else "public",

        "apiVersion": "ec2.aws.crossplane.io/v1beta1",
        "kind": "Subnet",
        "metadata": {
            "name": this.type + "-"+azs[i]
        },
        "spec": {
            "forProvider": {
                "cidrBlock": cidrs[i],
                "vpcIdRef": {
                    "name": vpc.metadata.name
                },
                "availabilityZone": vpc.spec.forProvider.region+azs[i],
                "tags": [
                    {
                        "key": "stack",
                        "value": vpc.metadata.name
                    },
                    {
                        "key": "Name",
                        "value": this.type+"-"+azs[i]
                    },
                    {
                        "key": "type",
                        "value": this.type
                    }
                ] +
                if cluster!=null then [{
                    "key": "kubernetes.io/cluster/"+cluster,
                    "value": "shared"
                }] else [] +
                if cluster!=null && is_private then [{
                    "key": "kubernetes.io/role/internal-elb",
                    "value": "1"
                }] else [] +
                if cluster!=null && !is_private then [{
                    "key": "kubernetes.io/role/elb",
                    "value": "1"
                }] else []
            },
            "providerConfigRef": vpc.spec.providerConfigRef
        }
    } for i in std.range(0, std.length(cidrs)-1)
]
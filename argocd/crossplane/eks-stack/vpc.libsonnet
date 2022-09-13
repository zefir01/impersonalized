function(provider_config="aws-provider",
    stack="test1",
    region="eu-central-1",
    vpc_cidr="10.0.0.0/16",
){
    "apiVersion": "ec2.aws.crossplane.io/v1beta1",
    "kind": "VPC",
    "metadata": {
        "name": stack
    },
    "spec": {
        "forProvider": {
            "cidrBlock": vpc_cidr,
            "enableDnsSupport": true,
            "enableDnsHostNames": true,
            "region": region,
            "tags": [
                {
                    "key": "Name",
                    "value": stack
                },
                {
                    "key": "stack",
                    "value": stack
                },
            ]
        },
        "providerConfigRef": {
            "name": provider_config
        }
    }
}
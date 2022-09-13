function(provider_config, name, description, stack, assume){
    "apiVersion": "iam.aws.crossplane.io/v1beta1",
    "kind": "Role",
    "metadata": {
        "name": name+"-"+stack,
    },
    "spec": {
        "forProvider": {
            "description": description,
            "assumeRolePolicyDocument": assume,
            "tags":[
                {
                    "key": "stack",
                    "value": stack
                }
            ]
        },
        "providerConfigRef": {
            "name": provider_config
        }
    }
}
function(provider_config, name, stack, role, policy=null, policyArn=null){

    assert (policy!=null || policyArn!=null) && (policy!=policyArn) : 'Specify policy OR policyArn',

    "apiVersion": "iam.aws.crossplane.io/v1beta1",
    "kind": "RolePolicyAttachment",
    "metadata": {
        "name": name+"-"+stack,
    },
    "spec": {
        "forProvider": {
            [if policy!=null then "policyArnRef"]: {
                "name": policy.metadata.name
            },
            [if policyArn!=null then "policyArn"]: policyArn,
            "roleNameRef": {
                "name": role.metadata.name
            },
        },
        "providerConfigRef": {
            "name": provider_config
        }
    }
}
function(name, description, stack, document){
    "apiVersion": "iam.aws.crossplane.io/v1beta1",
    "kind": "Policy",
    "metadata": {
        "name": name+"-"+stack,
    },
    "spec": {
        "forProvider": {
            "description": description,
            "name": name+"-"+stack,
            "document": document,
            "tags":[
                {
                    "key": "stack",
                    "value": stack
                }
            ]
        }
    }
}
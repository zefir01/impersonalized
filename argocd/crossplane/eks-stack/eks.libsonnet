function(vpc, subnets, stack, secretRef, role, name="eks", version="1.22", sgs=[]){
    "apiVersion": "eks.aws.crossplane.io/v1beta1",
    "kind": "Cluster",
    "metadata": {
        "name": name+"-"+stack
    },
    "spec": {
        "forProvider": {
            "region": vpc.spec.forProvider.region,
            "resourcesVpcConfig":{
                "endpointPrivateAccess": true,
                "endpointPublicAccess": true,
                "subnetIdRefs": [
                    {
                        "name": net.metadata.name
                    } for net in subnets
                ],
                securityGroupIdRefs: [
                    {
                        name: sg.metadata.name
                    } for sg in sgs
                ]
            },
            "roleArnRef":{
                "name": role.metadata.name
            },
            "version": version,
            "tags": {
                    "Name": name+"-"+stack,
                    "stack": stack
            }
        },
        "providerConfigRef": vpc.spec.providerConfigRef,
        "writeConnectionSecretToRef": secretRef
    }
}
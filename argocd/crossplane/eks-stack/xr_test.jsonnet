local xr_def = import "xr/xrd.libsonnet";
local comp = import "xr/comp.libsonnet";

function(provider_config="aws-provider")
{
    "xrd": xr_def("mycluster", "MyCluster", "mycluster",
            {
                "type": "object",
                properties: {
                    "region": {
                        "type": "string"
                    },
                    "subnetIdRefs":{
                        "type": "array",
                        "items": {
                            "type": "object"
                        }
                    },
                    "securityGroupIdRefs":{
                        "type": "array",
                        "items": {
                            "type": "object"
                        }
                    },
                    "roleArnRef": {
                        "type": "string"
                    },
                    "clusterVersion": {
                        "type": "string",
                        "default": "1.22"
                    },
                    "clusterName":{
                        "type": "string",
                    },
                    "stack":{
                        "type": "string",
                    },
                    "providerConfigRef": {
                        "type": "string",
                        "default": "default"
                    },
                    "kubeProxyVersion":{
                        "type": "string",
                        "default": "v1.22.6-eksbuild.1"
                    },
                    "vpcCniVersion":{
                        "type": "string",
                        "default": "v1.11.0-eksbuild.1"
                    },
                },
                "required": [
#                    "region",
#                    "subnetIdRefs",
#                    "securityGroupIdRefs",
#                    "roleArnRef",
#                    "clusterName",
#                    "stack",
#                    "writeConnectionSecretToRef"
                ]
            }
        ),
    "c": comp("test1", self.xrd),

    "apiVersion": "v1",
    "kind": "List",
    "items":[ self.xrd, self.c ]
}

/*
{
    "apiVersion": "blablabla.org/v1",
    "kind": "MyCluster",
    "metadata": {
        "namespace": "default",
        "name": "my-db"
    },
    "spec": {
        region: region,
        subnetIdRefs: [
            {
                "name": net.metadata.name
            } for net in private_subnets
        ],
        securityGroupIdRefs: [
            {
                name: sg.metadata.name
            } for sg in [ng_sg]
        ],
        roleArnRef: eks_role.metadata.name,
        clusterName: "xr-test",
        stack: stack,
        writeConnectionSecretToRef: {
            "namespace": "default",
            "name": "fff"
        }
    }
}
*/
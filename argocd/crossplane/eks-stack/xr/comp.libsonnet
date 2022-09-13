local eks = import "eks.libsonnet";

function(name, xrd){
    "apiVersion": "apiextensions.crossplane.io/v1",
    "kind": "Composition",
    "metadata": {
        "name": name,
        "labels": {
            "crossplane.io/xrd": xrd.metadata.name
        }
    },
    "spec": {
        "writeConnectionSecretsToNamespace": "default",
        "compositeTypeRef": {
            "apiVersion": xrd.spec.group+"/"+xrd.spec.versions[0].name,
            "kind": xrd.spec.names.kind
        },
        "resources": [
/*
            {
                "name": "eks",
                "base": {
                  "apiVersion": "eks.aws.crossplane.io/v1beta1",
                  "kind": "Cluster",
                  "metadata": {
                     "name": ""
                  },
                  "spec": {
                     "forProvider": {
                        "region": "",
                        "resourcesVpcConfig": {
                           "endpointPrivateAccess": true,
                           "endpointPublicAccess": true,
                           "subnetIdRefs": []
                        },
                        "roleArnRef": {
                           "name": ""
                        }
                     },
                     "providerConfigRef": {
                        "name": ""
                     },
                     "writeConnectionSecretToRef": {}
                  }
                },
                "patches": [
                    {
                        "type": "FromCompositeFieldPath",
                        "fromFieldPath": "spec.region",
                        "toFieldPath": "spec.forProvider.region"
                    },
                    {
                        "type": "FromCompositeFieldPath",
                        "fromFieldPath": "spec.subnetIdRefs",
                        "toFieldPath": "spec.forProvider.resourcesVpcConfig.subnetIdRefs"
                    },
                    {
                        "type": "FromCompositeFieldPath",
                        "fromFieldPath": "spec.securityGroupIdRefs",
                        "toFieldPath": "spec.forProvider.resourcesVpcConfig.securityGroupIdRefs"
                    },
                    {
                        "type": "FromCompositeFieldPath",
                        "fromFieldPath": "spec.roleArnRef",
                        "toFieldPath": "spec.forProvider.roleArnRef.name"
                    },
                    {
                        "type": "FromCompositeFieldPath",
                        "fromFieldPath": "spec.clusterVersion",
                        "toFieldPath": "spec.forProvider.version"
                    },
                    {
                        "type": "CombineFromComposite",
                        "combine": {
                            "variables": [
                                {
                                    "fromFieldPath": "spec.clusterName"
                                },
                                {
                                    "fromFieldPath": "spec.stack"
                                }
                            ],
                            "strategy": "string",
                            "string": {
                                "fmt": "%s-%s"
                            },
                        },
                        "policy": {
                            "fromFieldPath": "Required"
                        },
                        "toFieldPath": "metadata.name",
                    },
                    {
                        "type": "FromCompositeFieldPath",
                        "fromFieldPath": "spec.providerConfigRef",
                        "toFieldPath": "spec.providerConfigRef.name"
                    },
                    {
                        "type": "FromCompositeFieldPath",
                        "fromFieldPath": "spec.writeConnectionSecretToRef",
                        "toFieldPath": "spec.writeConnectionSecretToRef"
                    },
                ]
            },
            {
                "name": "kube-proxy-addon",
                "base": {
                    "apiVersion": "eks.aws.crossplane.io/v1alpha1",
                    "kind": "Addon",
                    "metadata": {
                        "name": ""
                    },
                    "spec": {
                        "forProvider": {
                            "addonName": "kube-proxy",
                            "clusterNameRef": {
                                "name": ""
                            },
                            "region": "",
                            "resolveConflicts": "OVERWRITE",
                            "addonVersion": ""
                        },
                        "providerConfigRef": {
                            "name": ""
                        }
                    }
                },
                "patches": [
                    {
                        "type": "CombineFromComposite",
                        "combine": {
                            "variables": [
                                {
                                    "fromFieldPath": "spec.clusterName"
                                },
                                {
                                    "fromFieldPath": "spec.stack"
                                }
                            ],
                            "strategy": "string",
                            "string": {
                                "fmt": "%s-%s"
                            },
                        },
                        "toFieldPath": "spec.forProvider.clusterNameRef",
                        "policy": {
                            "fromFieldPath": "Required"
                        }
                    },
                    {
                        "type": "FromCompositeFieldPath",
                        "fromFieldPath": "spec.region",
                        "toFieldPath": "spec.forProvider.region"
                    },
                    {
                        "type": "FromCompositeFieldPath",
                        "fromFieldPath": "spec.providerConfigRef",
                        "toFieldPath": "spec.providerConfigRef.name"
                    },
                    {
                        "type": "FromCompositeFieldPath",
                        "fromFieldPath": "spec.kubeProxyVersion",
                        "toFieldPath": "spec.forProvider.addonVersion"
                    }
                ]

            },
            {
                "name": "vpc-cni-addon",
                "base": {
                    "apiVersion": "eks.aws.crossplane.io/v1alpha1",
                    "kind": "Addon",
                    "metadata": {
                        "name": ""
                    },
                    "spec": {
                        "forProvider": {
                            "addonName": "kube-proxy",
                            "clusterNameRef": {
                                "name": ""
                            },
                            "region": "",
                            "resolveConflicts": "OVERWRITE",
                            "addonVersion": ""
                        },
                        "providerConfigRef": {
                            "name": ""
                        }
                    }
                },
                "patches": [
                    {
                        "type": "CombineFromComposite",
                        "combine": {
                            "variables": [
                                {
                                    "fromFieldPath": "spec.clusterName"
                                },
                                {
                                    "fromFieldPath": "spec.stack"
                                }
                            ],
                            "strategy": "string",
                            "string": {
                                "fmt": "%s-%s"
                            },
                        },
                        "toFieldPath": "spec.forProvider.clusterNameRef",
                        "policy": {
                            "fromFieldPath": "Required"
                        }
                    },
                    {
                        "type": "FromCompositeFieldPath",
                        "fromFieldPath": "spec.region",
                        "toFieldPath": "spec.forProvider.region"
                    },
                    {
                        "type": "FromCompositeFieldPath",
                        "fromFieldPath": "spec.providerConfigRef",
                        "toFieldPath": "spec.providerConfigRef.name"
                    },
                    {
                        "type": "FromCompositeFieldPath",
                        "fromFieldPath": "spec.vpcCniVersion",
                        "toFieldPath": "spec.forProvider.addonVersion"
                    }
                ]

            }
            */
        ]
    }
}
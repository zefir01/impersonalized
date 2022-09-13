local xrd = import "xrd.libsonnet";
local comp = import "comp.libsonnet";
local vpc = import "../vpc.libsonnet";

local rm_meta=function(res) res+{metadata:: {}};

local make_res=function(name, res, patches){
    name: name,
    base: rm_meta(res),
    patches: patches
};



function(){
    local test={
        name: "res1",
        "base": {
            apiVersion: "eks.aws.crossplane.io/v1beta1",
            kind: "Cluster",
            spec: {
                forProvider: {
                    region: "",
                    resourcesVpcConfig: {
                        endpointPrivateAccess: true,
                        endpointPublicAccess: true,
                        subnetIdRefs: []
                    },
                    roleArnRef: {
                        name: ""
                    }
                },
                providerConfigRef: {
                    name: ""
                },
                writeConnectionSecretToRef: {}
            }
        },
        patches: [
            {
                type: "ToCompositeFieldPath",
                fromFieldPath: "spec.region",
                toFieldPath: "region"
            },
            {
                type: "CombineToComposite",
                combine: {
                    variables: [
                        {
                            fromFieldPath: "spec.clusterName"
                        },
                        {
                            fromFieldPath: "spec.stack"
                        }
                    ],
                    strategy: "string",
                    string: {
                        fmt: "%s-%s"
                    },
                },
                toFieldPath: "clusterNameRef",
                policy: {
                    fromFieldPath: "Required"
                }
            }
        ],
    },
    local test1=make_res("vpc", vpc(),[
        {
            type: "ToCompositeFieldPath",
            fromFieldPath: "spec.parameters.vpc-cidrBlock",
            toFieldPath: "cidrBlock"
        }
    ]),

    xrd: xrd("test1", "MyCluster", "mucluster", {}, [test1]),
    comp: comp("myEks", self.xrd, [test1])
}
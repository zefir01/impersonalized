#sed -E 's/(^ *)"([^"]*)":/\1\2:/'
local lib=import "lib.libsonnet";
local _cni = import "cni.libsonnet";
local cni = _cni("eu-central-1");
local userData=importstr "user_data.txt";

local awsCommonPatchset=lib.patchset("aws-common-parameters");
{
    apiVersion: "apiextensions.crossplane.io/v1",
    kind: "Composition",
    metadata: {
        name: "network",
        labels: {
            provider: "aws",
            service: "eks",
            compute: "managed"
        }
    },
    spec: {
        writeConnectionSecretsToNamespace: "crossplane-system",
        compositeTypeRef: {
            apiVersion: "blablabla.org/v1beta1",
            kind: "Network"
        },
        patchSets: [
            {
                name: "aws-common-parameters",
                patches: [
                    {
                        fromFieldPath: "spec.parameters.region",
                        toFieldPath: "spec.forProvider.region"
                    },
                    {
                        fromFieldPath: "spec.parameters.awsProviderConfig",
                        toFieldPath: "spec.providerConfigRef.name"
                    }
                ]
            }
        ],
        resources: [

            lib.vpc("vpc", [
                awsCommonPatchset,
                lib.fromComposite("spec.parameters.vpc-cidrBlock", "spec.forProvider.cidrBlock"),
                lib.fromComposite("spec.parameters.vpc-name", "spec.forProvider.tags[0].value"),
            ],),

            lib.igw("InternetGateway", {type: "igw"}, [
                awsCommonPatchset,
                lib.combineFromComposite(
                        [
                            "spec.parameters.vpc-name",
                        ], 
                        "%s-igw", "spec.forProvider.tags[0].value")
            ]),

            lib.subnet("subnet-public-1",
                {
                    type: "subnet",
                    visibility: "public"
                },
                true,
                [{
                    key: "kubernetes.io/role/elb",
                    value: "1"
                }],
                [
                    awsCommonPatchset,
                    lib.combineFromComposite(
                        [
                            "spec.parameters.vpc-name",
                            "spec.parameters.subnet1-public-name"
                        ], 
                        "%s-%s", "spec.forProvider.tags[0].value"),
                    lib.fromComposite("spec.parameters.subnet1-public-cidrBlock", "spec.forProvider.cidrBlock"),
                    lib.fromComposite("spec.parameters.region", "spec.forProvider.availabilityZone",
                        [lib.strTransform("%sa")]
                    ),
                    lib.fromComposite("spec.parameters.region", "metadata.labels.zone",
                        [lib.strTransform("%sa")]
                    ),
                
                ]
            ),


            lib.subnet("subnet-public-2",
                {
                    type: "subnet",
                    visibility: "public"
                },
                true,
                [{
                    key: "kubernetes.io/role/elb",
                    value: "1"
                }],
                [
                    awsCommonPatchset,
                    lib.combineFromComposite(
                        [
                            "spec.parameters.vpc-name",
                            "spec.parameters.subnet2-public-name"
                        ], 
                        "%s-%s", "spec.forProvider.tags[0].value"),
                    lib.fromComposite("spec.parameters.subnet2-public-cidrBlock", "spec.forProvider.cidrBlock"),
                    lib.fromComposite("spec.parameters.region", "spec.forProvider.availabilityZone",
                        [lib.strTransform("%sb")]
                    ),
                    lib.fromComposite("spec.parameters.region", "metadata.labels.zone",
                        [lib.strTransform("%sb")]
                    ),
                
                ]
            ),
            

            lib.subnet("subnet-private-1",
                {
                    type: "subnet",
                    visibility: "private"
                },
                false,
                [{
                    key: "kubernetes.io/role/internal-elb",
                    value: "1"
                }],
                [
                    awsCommonPatchset,
                    lib.combineFromComposite(
                        [
                            "spec.parameters.vpc-name",
                            "spec.parameters.subnet1-private-name"
                        ], 
                        "%s-%s", "spec.forProvider.tags[0].value"),
                    lib.fromComposite("spec.parameters.subnet1-private-cidrBlock", "spec.forProvider.cidrBlock"),
                    lib.fromComposite("spec.parameters.region", "spec.forProvider.availabilityZone",
                        [lib.strTransform("%sa")]
                    ),
                    lib.fromComposite("spec.parameters.region", "metadata.labels.zone",
                        [lib.strTransform("%sa")]
                    ),
                
                ]
            ),

            lib.subnet("subnet-private-2",
                {
                    type: "subnet",
                    visibility: "private"
                },
                false,
                [{
                    key: "kubernetes.io/role/internal-elb",
                    value: "1"
                }],
                [
                    awsCommonPatchset,
                    lib.combineFromComposite(
                        [
                            "spec.parameters.vpc-name",
                            "spec.parameters.subnet2-private-name"
                        ], 
                        "%s-%s", "spec.forProvider.tags[0].value"),
                    lib.fromComposite("spec.parameters.subnet2-private-cidrBlock", "spec.forProvider.cidrBlock"),
                    lib.fromComposite("spec.parameters.region", "spec.forProvider.availabilityZone",
                        [lib.strTransform("%sb")]
                    ),
                    lib.fromComposite("spec.parameters.region", "metadata.labels.zone",
                        [lib.strTransform("%sb")]
                    ),
                
                ]
            ),

            lib.eip("elastic-ip-1", {type: "eip-1"}, [awsCommonPatchset]),
            lib.eip("elastic-ip-2", {type: "eip-2"}, [awsCommonPatchset]),
            
            lib.natGw("natgateway-1", {type: "natgw-1"}, {type: "eip-1"}, 
                {
                    type: "subnet",
                    visibility: "private"
                },
                [
                    awsCommonPatchset,
                    lib.combineFromComposite(["spec.parameters.vpc-name"], "%s-nat-gateway-2", "spec.forProvider.tags[0].value"),
                    lib.fromComposite("spec.parameters.region", "spec.forProvider.subnetIdSelector.matchLabels.zone",
                        [lib.strTransform("%sa")]
                    ),
                ],
            ),

            lib.natGw("natgateway-2", {type: "natgw-2"}, {type: "eip-2"}, 
                {
                    type: "subnet",
                    visibility: "private"
                },
                [
                    awsCommonPatchset,
                    lib.combineFromComposite(["spec.parameters.vpc-name"], "%s-nat-gateway-2", "spec.forProvider.tags[0].value"),
                    lib.fromComposite("spec.parameters.region", "spec.forProvider.subnetIdSelector.matchLabels.zone",
                        [lib.strTransform("%sb")]
                    ),
                ],
            ),
            
            lib.routeTable("routetable-public", 
                [{
                    type: "subnet",
                    visibility: "public",
                },
                {
                    type: "subnet",
                    visibility: "public"
                }],
                [
                    lib.combineFromComposite(["spec.parameters.vpc-name"], "%s-private-route-table-1", "spec.forProvider.tags[0].value"),
                    awsCommonPatchset,
                    lib.fromComposite("spec.parameters.region", 
                        "spec.forProvider.associations[0].subnetIdSelector.matchLabels.zone",
                        [lib.strTransform("%sa")]),
                    lib.fromComposite("spec.parameters.region", 
                        "spec.forProvider.associations[1].subnetIdSelector.matchLabels.zone",
                        [lib.strTransform("%sb")])
                ], igwLabels={type: "igw"}),
            
            lib.routeTable("routetable-private-1", 
                [{
                    type: "subnet",
                    visibility: "private"
                }],
                [
                    lib.combineFromComposite(["spec.parameters.vpc-name"], "%s-private-route-table-1", "spec.forProvider.tags[0].value"),
                    awsCommonPatchset,
                    lib.fromComposite("spec.parameters.region", 
                        "spec.forProvider.associations[0].subnetIdSelector.matchLabels.zone",
                        [lib.strTransform("%sa")],)
                ], natGatewayLabels={type: "natgw-1"}),

            lib.routeTable("routetable-private-2", 
                [{
                    type: "subnet",
                    visibility: "private"
                }],
                [
                    lib.combineFromComposite(["spec.parameters.vpc-name"], "%s-private-route-table-2", "spec.forProvider.tags[0].value"),
                    awsCommonPatchset,
                    lib.fromComposite("spec.parameters.region", 
                        "spec.forProvider.associations[0].subnetIdSelector.matchLabels.zone",
                        [lib.strTransform("%sb")],)
                ], natGatewayLabels={type: "natgw-2"}),
                
            lib.role("eks-role", {type: "eks-role"}, |||
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "EKSClusterAssumeRole",
                "Effect": "Allow",
                "Principal": {
                    "Service": "eks.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
|||,
                [
                    lib.combineFromComposite(["metadata.name"], "%s-eks-role", "spec.forProvider.tags[0].value"),
                    awsCommonPatchset,
                    lib.toComposite("status.atProvider.arn", "spec.outputs.eksRoleArn")
                ] 
            ),

            lib.iamAttache("eks-role-attache1", {type: "eks-role"}, patches=[awsCommonPatchset], policyArn="arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"),
            lib.iamAttache("eks-role-attache2", {type: "eks-role"}, patches=[awsCommonPatchset], policyArn="arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"),

            lib.sg("eks-ng-sg", {type: "eks-ng-sg"}, "EKS cluster security group", 
                [
                    awsCommonPatchset,
                    lib.toComposite("status.atProvider.securityGroupID", "spec.outputs.eksNgSecurityGroupId")
                ], ingress_all=true, egress_all=true),

            lib.eks("eks-cluster", {type: "subnet"}, {type: "eks-ng-sg"}, "default", "eks-test", [
                awsCommonPatchset,
                lib.fromComposite("spec.outputs.eksRoleArn", "spec.forProvider.roleArn"),
                lib.fromComposite("spec.parameters.eksSecretName", "spec.writeConnectionSecretToRef.name"),
                lib.fromComposite("spec.parameters.eksSecretNamespace", "spec.writeConnectionSecretToRef.namespace"),
                lib.toComposite("status.atProvider.identity.oidc.issuer", "spec.outputs.eksOidc",
                [
                    lib.trimPrefixTransform("https://")
                ],),
                lib.toComposite("status.atProvider.resourcesVpcConfig.clusterSecurityGroupId", "spec.outputs.eksSecurityGrpupId"),
                lib.toComposite("metadata.name", "spec.outputs.eksClusterName")
           ]),

           lib.k8sPrividerConfig("cluster-config", [
                lib.fromComposite("spec.parameters.eksSecretName", "spec.credentials.secretRef.name"),
                lib.fromComposite("spec.parameters.eksSecretNamespace", "spec.credentials.secretRef.namespace"),
                lib.toComposite("metadata.name", "spec.outputs.eksProviderConfigName")
           ]),

            

            #lib.launchTemplate("eks-node-template", [
            #    lib.combineFromComposite(["spec.outputs.eksClusterName"], userData, "spec.forProvider.launchTemplateData.userData")
            #])
           
           
        ] +
        [
            lib.object("cni"+i, cni.items[i], 
           [
               lib.fromComposite("spec.outputs.eksProviderConfigName", "spec.providerConfigRef.name"),
           ]) for i in std.range(0, std.length(cni.items)-1)
        ],
    }
}
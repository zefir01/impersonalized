{
    local _combineFromComposite=function(fromFields, fmt, toField){
        type: "CombineFromComposite",
        combine: {
            variables: [
                {
                    fromFieldPath: field
                } for field in fromFields
            ],
            strategy: "string",
            string: {
                fmt: fmt
            }
        },
        toFieldPath: toField,
        policy: {
            fromFieldPath: "Required"
        }
    },
    combineFromComposite:: _combineFromComposite,

    local _fromComposite = function(fromField, toFieldPath, transforms=null){
        fromFieldPath: fromField,
        toFieldPath: toFieldPath,
        [if transforms!=null then "transforms"]: transforms,
    },
    fromComposite:: _fromComposite,

    local _toComposite = function(fromField, toFieldPath, transforms=null){
        type: "ToCompositeFieldPath",
        fromFieldPath: fromField,
        toFieldPath: toFieldPath,
        [if transforms!=null then "transforms"]: transforms,
    },
    toComposite:: _toComposite,

    local _strTransform = function(fmt){
        type: "string",
        string: {
            fmt: fmt
        },
    },
    strTransform:: _strTransform,

    local _trimPrefixTransform=function(prefix){
        type: "string",
        string: {
            type: "TrimPrefix",
            trim: prefix
        },
    },
    trimPrefixTransform:: _trimPrefixTransform,

    local _patchset=function(name){
        type: "PatchSet",
        patchSetName: name
    },
    patchset:: _patchset,

    local _iamAttache = function(name, roleLabels, patches=[], policyLabels=null, policyArn=null){
        name: name,
        base: {
            apiVersion: "iam.aws.crossplane.io/v1beta1",
            kind: "RolePolicyAttachment",
            spec: {
                forProvider: {
                    roleNameSelector: {
                        matchLabels: roleLabels
                    },
                    [if policyLabels!=null then "policyArnSelector"]: {
                        matchLabels: policyLabels
                    },
                    [if policyArn!=null then "policyArn"]: policyArn,
                },
            }
        },
        patches: patches + [
            _combineFromComposite(["metadata.name"], "%s-"+name, "spec.forProvider.name"),
        ],
    },
    iamAttache:: _iamAttache,

    local _role = function(name, labels, document, patches){
        name: name,
        base: {
            apiVersion: "iam.aws.crossplane.io/v1beta1",
            kind: "Role",
            metadata: {
                labels: labels,
            },
            spec: {
                forProvider: {
                    assumeRolePolicyDocument: document,
                    tags: [
                        {
                            key: "Name"
                        }
                    ]
                },
            }
        },
        patches: patches
    },
    role:: _role,

    local _routeTable = function(name, subnetLabels, patches, natGatewayLabels=null, igwLabels=null, 
        vpcIdSelector={matchControllerRef: true}){
        name: name,
        base: {
            apiVersion: "ec2.aws.crossplane.io/v1beta1",
            kind: "RouteTable",
            spec: {
                forProvider: {
                    vpcIdSelector: vpcIdSelector,
                    routes: [
                        {
                            destinationCidrBlock: "0.0.0.0/0",
                            [if natGatewayLabels!=null then "natGatewayIdSelector"]: {
                                matchLabels: natGatewayLabels
                            },
                            [if igwLabels!=null then "gatewayIdSelector"]: {
                                matchLabels: igwLabels
                            }
                        }
                    ],
                    associations: [
                        {
                            subnetIdSelector: {
                                matchLabels: lab
                            }
                        } for lab in subnetLabels
                    ],
                    tags: [
                        {
                            key: "Name"
                        }
                    ]
                }
            }
        },
        patches: patches
    },
    routeTable:: _routeTable,

    local _natGw = function(name, labels, allocationLabels, subnetLabels, patches, vpcIdSelector={matchControllerRef: true}){
        name: name,
        base: {
            apiVersion: "ec2.aws.crossplane.io/v1beta1",
            kind: "NATGateway",
            metadata: {
                labels: labels
            },
            spec: {
                forProvider: {
                    allocationIdSelector: {
                        matchLabels: allocationLabels
                    },
                    vpcIdSelector: vpcIdSelector,
                    subnetIdSelector: {
                        matchLabels: subnetLabels
                    },
                    tags: [
                        {
                            key: "Name"
                        }
                    ]
                }
            }
        },
        patches: patches
    },
    natGw:: _natGw,

    local _eip = function(name, labels, patches){
        name: name,
        base: {
            apiVersion: "ec2.aws.crossplane.io/v1beta1",
            kind: "Address",
            metadata: {
                labels: labels
            },
            spec: {
                forProvider: {
                    domain: "vpc"
                }
            }
        },
        patches: patches
    },
    eip:: _eip,

    local _subnet = function(name, labels, isPublic, tags, patches, vpcIdSelector={matchControllerRef: true}){
        name: name,
        base: {
            apiVersion: "ec2.aws.crossplane.io/v1beta1",
            kind: "Subnet",
            metadata: {
                labels: labels
            },
            spec: {
                forProvider: {
                    mapPublicIpOnLaunch: isPublic,
                    vpcIdSelector: vpcIdSelector,
                    tags: [
                        {
                            key: "Name"
                        },
                    ] + tags
                }
            }
        },
        patches: patches
    },
    subnet:: _subnet,

    local _igw = function(name, labels, patches, tags=[], vpcIdSelector={matchControllerRef: true}){
        name: name,
        base: {
            apiVersion: "ec2.aws.crossplane.io/v1beta1",
            kind: "InternetGateway",
            metadata: {
                labels: labels
            },
            spec: {
                forProvider: {
                    vpcIdSelector: vpcIdSelector,
                    tags: [
                        {
                            key: "Name"
                        }
                    ] + tags
                }
            }
        },
        patches: patches
    },
    igw:: _igw,

    local _vpc = function(name, patches, tags=[]){
        name: name,
        base: {
            apiVersion: "ec2.aws.crossplane.io/v1beta1",
            kind: "VPC",
            spec: {
                forProvider: {
                    enableDnsSupport: true,
                    enableDnsHostNames: true,
                    tags: [
                        {
                            key: "Name"
                        }
                    ] + tags
                }
            }
        },
        patches: patches
    },
    vpc:: _vpc,

    local _eks = function(name, subnetLabels, sgLabels, secretNs, secretName, patches, version="1.22"){
        name: name,
        base: {
            apiVersion: "eks.aws.crossplane.io/v1beta1",
            kind: "Cluster",
            spec: {
                forProvider: {
                    resourcesVpcConfig: {
                        endpointPrivateAccess: false,
                        endpointPublicAccess: true,
                        subnetIdSelector: {
                            matchLabels: subnetLabels
                        },
                        securityGroupIdSelector:{
                            matchLabels: sgLabels
                        },
                    },
                    version: version
                }
            }
        },
        patches: patches
    },
    eks:: _eks,

    local _sg=function(name, labels, description, patches, ingress=[], egress=[], ingress_all=false, egress_all=false, 
        vpcIdSelector={matchControllerRef: true}){
        local all={
            fromPort: null,
            toPort: null,
            ipProtocol: "-1",
            ipRanges: [
                {
                    cidrIp: "0.0.0.0/0"
                }
            ]
        },

        name: name,
        base: {
            apiVersion: "ec2.aws.crossplane.io/v1beta1",
            kind: "SecurityGroup",
            metadata:{
                labels: labels
            },
            spec: {
                forProvider: {
                    description: description,
                    vpcIdSelector: vpcIdSelector,
                    ingress: ingress + if ingress_all then [all] else [],
                    egress: egress + if egress_all then [all] else [],
                },
            }
        },
        patches: patches + [
            _combineFromComposite(["metadata.name"], "%s-"+name, "spec.forProvider.groupName"),
        ],
    },
    sg:: _sg,

    local _k8sPrividerConfig = function(name, patches)
    {
        name: name,
        base: {
            apiVersion: "kubernetes.crossplane.io/v1alpha1",
            kind: "ProviderConfig",
            spec: {
                credentials: {
                    source: "Secret",
                    secretRef: {
                        key: "kubeconfig"
                    }
                }
            }
        },
        patches: patches
    },
    k8sPrividerConfig:: _k8sPrividerConfig,

    local _object = function(name, manifest, patches){
        name: name,
        base: {
            "apiVersion": "kubernetes.crossplane.io/v1alpha1",
            "kind": "Object",
            "spec": {
                "forProvider": {
                    "manifest": manifest
                },
            }
        },
        patches: patches
    },
    object:: _object,

    local _launchTemplate = function(name, patches){
        
        name: name,
        base: {
            apiVersion: "ec2.aws.crossplane.io/v1alpha1",
            kind: "LaunchTemplate",
            spec: {
                forProvider: {
                    #launchTemplateName: name+"-"+stack
                },
            }
        },
        patches: patches,
    },
    launchTemplate:: _launchTemplate

}
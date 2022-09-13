{
    apiVersion: "apiextensions.crossplane.io/v1",
    kind: "CompositeResourceDefinition",
    metadata: {
        name: "network.blablabla.org"
    },
    spec: {
        group: "blablabla.org",
        names: {
            kind: "Network",
            plural: "network"
        },
        connectionSecretKeys: [
            "cluster-ca",
            "apiserver-endpoint",
            "value"
        ],
        versions: [
            {
                name: "v1beta1",
                served: true,
                referenceable: true,
                schema: {
                    openAPIV3Schema: {
                        type: "object",
                        properties: {
                            spec: {
                                type: "object",
                                properties: {
                                    outputs: {
                                        type: "object",
                                        properties: {
                                            eksRoleArn: {
                                                type: "string"
                                            },
                                            eksOidc: {
                                                type: "string"
                                            },
                                            eksSecurityGrpupId: {
                                                type: "string"
                                            },
                                            eksNgSecurityGroupId: {
                                                type: "string"
                                            },
                                            eksProviderConfigName: {
                                                type: "string"
                                            },
                                            eksClusterName: {
                                                type: "string",
                                            },
                                        },
                                    },
                                    parameters: {
                                        type: "object",
                                        properties: {
                                            region: {
                                                description: "Geographic location of this VPC",
                                                type: "string",
                                            },
                                            "vpc-cidrBlock": {
                                                description: "CIDR block for VPC",
                                                type: "string"
                                            },
                                            "vpc-name": {
                                                description: "Name for VPC",
                                                type: "string"
                                            },
                                            "subnet1-public-name": {
                                                description: "Name for public subnet 1",
                                                type: "string"
                                            },
                                            "subnet1-public-cidrBlock": {
                                                description: "CIDR block for public subnet 1",
                                                type: "string"
                                            },
                                            "subnet2-public-name": {
                                                description: "Name for public subnet 2",
                                                type: "string"
                                            },
                                            "subnet2-public-cidrBlock": {
                                                description: "CIDR block for public subnet 2",
                                                type: "string"
                                            },
                                            "subnet1-private-name": {
                                                description: "Name for private subnet 1",
                                                type: "string"
                                            },
                                            "subnet1-private-cidrBlock": {
                                                description: "CIDR block for private subnet 1",
                                                type: "string"
                                            },
                                            "subnet2-private-name": {
                                                description: "Name for private subnet 2",
                                                type: "string"
                                            },
                                            "subnet2-private-cidrBlock": {
                                                description: "CIDR block for private subnet 2",
                                                type: "string"
                                            },
                                            awsProviderConfig: {
                                                type: "string",
                                                default: "aws-provider"
                                            },
                                            eksSecretName: {
                                                type: "string"
                                            },
                                            eksSecretNamespace: {
                                                type: "string"
                                            },
                                        },
                                        required: [
                                            "region",
                                            "vpc-name",
                                            "vpc-cidrBlock",
                                            "subnet1-public-name",
                                            "subnet1-public-cidrBlock",
                                            "subnet2-public-name",
                                            "subnet2-public-cidrBlock",
                                            "subnet1-private-name",
                                            "subnet1-private-cidrBlock",
                                            "subnet2-private-name",
                                            "subnet2-private-cidrBlock",
                                            "eksSecretName",
                                            "eksSecretNamespace"
                                        ]
                                    }
                                },
                                required: [
                                    "parameters"
                                ]
                            }
                        }
                    }
                }
            }
        ]
    }
}
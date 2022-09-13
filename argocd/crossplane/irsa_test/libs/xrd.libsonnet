function(name, domain, outputs=null, params=null){

    local field=function(field){
        [field]: {
            type: "string"
        },
    },

    apiVersion: "apiextensions.crossplane.io/v1",
    kind: "CompositeResourceDefinition",
    metadata: {
        name: name+"."+domain
    },
    spec: {
        group: domain,
        names: {
            kind: std.asciiUpper(std.substr(name, 0, 1))+std.substr(name, 1, std.length(name)-1),
            plural: name
        },
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
                                    [if outputs!=null then "outputs"]: {
                                        type: "object",
                                        properties: std.foldl(function(r, r1) (r+field(r1)), outputs, {}),
                                    },
                                    parameters: {
                                        type: "object",
                                        properties: {
                                            region: {
                                                description: "EKS region",
                                                type: "string",
                                            },
                                            awsProviderConfig:{
                                                type: "string",
                                                default: "aws-provider"
                                            },
                                            
                                        } + if params!=null then params else {},
                                        required: [
                                            "region",
                                        ] +
                                        [
                                            n for n in std.filter(function(p) !std.objectHasAll(params[p], "default"), std.objectFields(params))
                                        ],
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
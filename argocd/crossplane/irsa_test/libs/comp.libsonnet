local lib=import "lib.libsonnet";

local awsCommonPatchset=lib.patchset("aws-common-parameters");

function(name, domain, resources){
    apiVersion: "apiextensions.crossplane.io/v1",
    kind: "Composition",
    metadata: {
        name: name,
        labels: {
            provider: "aws",
            service: "eks",
            compute: "managed"
        }
    },
    spec: {
        writeConnectionSecretsToNamespace: "crossplane-system",
        compositeTypeRef: {
            apiVersion: domain+"/v1beta1",
            kind: std.asciiUpper(std.substr(name, 0, 1))+std.substr(name, 1, std.length(name)-1)
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
        resources: [res + {
            patches: if std.endsWith(res.base.apiVersion, "aws.crossplane.io/v1beta1") then
                if std.objectHas(res, "patches") then res.patches+[awsCommonPatchset] else [awsCommonPatchset]
            else res.patches
        }, for res in resources],
    }
}
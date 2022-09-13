local eks = import "libs/eks.libsonnet";
local xrd = import "libs/xrd.libsonnet";
local comp = import "libs/comp.libsonnet";
local lib=import "libs/lib.libsonnet";

comp("irsa", "blablabla.org", [
    eks("main", patches=[
        lib.toComposite("status.atProvider.identity.oidc.issuer", "spec.outputs.eksOidc",
            [
                lib.trimPrefixTransform("https://")
            ]
        )
    ]),
    lib.iamAttache("irsa-attach", rolesMatchControllerRef=true, 
        patches=[
            lib.fromComposite("spec.parameters.policyLabels", "spec.forProvider.policyArnSelector.matchLabels"),
        ]
    ),

    lib.role("irsa-role", {}, patches=[
        lib.combineFromComposite([
                "spec.outputs.eksOidc",
                "spec.outputs.eksOidc",
                "spec.parameters.saNamespace",
                "spec.parameters.saName"
            ], 
            importstr "irsa_policy.tpl", "spec.forProvider.assumeRolePolicyDocument"
        ),
        lib.toComposite("status.atProvider.arn", "spec.outputs.roleArn")
    ]),

    lib.object("sa", {
            apiVersion: "v1",
            kind: "ServiceAccount",
            metadata: {
                name: "test1",
                namespace: "default",
            }
        },
        [
            lib.fromComposite("spec.outputs.roleArn", "spec.forProvider.manifest.metadata.annotations['eks.amazonaws.com/role-arn']"),
            lib.fromComposite("spec.parameters.localK8sProviderConfig", "spec.providerConfigRef.name")
        ],
        managementPolicy="ObserveCreateUpdate"
    )

])
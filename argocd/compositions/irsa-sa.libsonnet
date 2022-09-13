local cp = import '../libs/crossplane.libsonnet';

local domain = std.extVar('domain');

[
  cp.xrd(
    'irsa-sa',
    domain,
    params={
      saNamespace: {
        type: 'string',
      },
      saName: {
        type: 'string',
      },
      policyLabels: {
        type: 'object',
        'x-kubernetes-preserve-unknown-fields': true,
      },
      accountId: {
        type: 'string',
      },
      clusterName: {
        type: 'string',
      },
    },
  ),

  cp.comp('irsa-sa', domain, [
    cp.eksImport('main', patches=[
      cp.toComposite(
        'status.atProvider.identity.oidc.issuer',
        'status.outputs.eksOidc',
        [
          cp.trimPrefixTransform('https://'),
        ]
      ),
      cp.fromComposite('spec.parameters.clusterName', "metadata.annotations['crossplane.io/external-name']"),
    ]),
    cp.eksImportK8sProviderConfig('mainEksPC', 'main'),

    cp.iamAttache(
      'irsa-attach',
      rolesMatchControllerRef=true,
      patches=[
        cp.fromComposite('spec.parameters.policyLabels', 'spec.forProvider.policyArnSelector.matchLabels'),
      ]
    ),

    cp.role('irsa-role', {}, patches=[
      cp.combineFromComposite(
        [
          'spec.parameters.accountId',
          'status.outputs.eksOidc',
          'status.outputs.eksOidc',
          'spec.parameters.saNamespace',
          'spec.parameters.saName',
        ],
        importstr 'irsa_policy.tpl',
        'spec.forProvider.assumeRolePolicyDocument'
      ),
      cp.toComposite('status.atProvider.arn', 'status.outputs.roleArn'),
    ]),

    cp.object(
      'sa',
      {
        apiVersion: 'v1',
        kind: 'ServiceAccount',
      },
      [
        cp.fromComposite('status.outputs.roleArn', "spec.forProvider.manifest.metadata.annotations['eks.amazonaws.com/role-arn']"),
        cp.fromComposite('spec.parameters.saNamespace', 'spec.forProvider.manifest.metadata.namespace'),
        cp.fromComposite('spec.parameters.saName', 'spec.forProvider.manifest.metadata.name'),

        cp.fromComposite('status.outputs.mainEksPC.name', 'spec.providerConfigRef.name'),
      ],
      managementPolicy='ObserveCreateUpdate'
    ),

  ]),
]

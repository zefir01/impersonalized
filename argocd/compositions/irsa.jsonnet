local cp = import '../libs/crossplane.libsonnet';

local domain = std.extVar('domain');

[
  cp.xrd(
    'irsa',
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
      eksOidc: {
        type: 'string',
      },
    },
  ),

  cp.comp('irsa', domain, [
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
          'spec.parameters.eksOidc',
          'spec.parameters.eksOidc',
          'spec.parameters.saNamespace',
          'spec.parameters.saName',
        ],
        importstr 'irsa_policy.tpl',
        'spec.forProvider.assumeRolePolicyDocument'
      ),
      cp.toComposite('status.atProvider.arn', 'status.outputs.roleArn'),
    ]),

  ]),
]

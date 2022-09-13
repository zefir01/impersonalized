local argo = import '../libs/argo.libsonnet';
local cp = import '../libs/crossplane.libsonnet';

local domain = std.extVar('domain');

[
  cp.xrd(
    'argoeks',
    domain,
    params={
      clusterName: {
        type: 'string',
      },
      environment: {
        type: 'string',
      },
      accountId: {
        type: 'string',
      },
      ampUrl: {
        type: 'string',
      },
    },
  ),


  cp.comp('argoeks', domain, [
    cp.eksImport('cluster', patches=[
      cp.toComposite(
        'status.atProvider.identity.oidc.issuer',
        'status.outputs.eksOidc',
        [
          cp.trimPrefixTransform('https://'),
        ]
      ),
      cp.fromComposite('spec.parameters.clusterName', "metadata.annotations['crossplane.io/external-name']"),
    ]),

    cp.object(
      'cluster-secret',
      {
        apiVersion: 'v1',
        kind: 'Secret',
      },
      [
        cp.fromComposite('spec.writeConnectionSecretToRef.name', 'spec.forProvider.manifest.metadata.name'),
        cp.fromComposite('spec.writeConnectionSecretToRef.namespace', 'spec.forProvider.manifest.metadata.namespace'),

        cp.toComposite('status.atProvider.manifest.data.cluster-clusterCA', 'status.outputs.clusterCA'),
        cp.toComposite(
          'status.atProvider.manifest.data.cluster-endpoint',
          'status.outputs.clusterEndpoint',
          transforms=[
            cp.fromBase64Transform(),
          ],
        ),
        cp.toComposite(
          'status.atProvider.manifest.data.cluster-kubeconfig',
          'status.outputs.clusterKubeconfig',
          transforms=[
            cp.fromBase64Transform(),
          ],
        ),
      ],
      managementPolicy='Observe'
    ),


    cp.object(
      'cluster-secret-app',
      argo.app(
        '',
        'argo',
        'git@github.com:blablabla/argocd',
        'argo-eks/cluster-secret',
        vars=[
          {
            name: 'region',
          },
          {
            name: 'name',
          },
          {
            name: 'kubeconfig',
          },
        ],
      ),
      [
        cp.combineFromComposite(
          [
            'spec.parameters.environment',
            'spec.parameters.region',
            'spec.parameters.clusterName',
          ],
          'eks-%s-%s-%s-secret',
          'spec.forProvider.manifest.metadata.name',
        ),

        cp.fromComposite('spec.parameters.environment', 'spec.forProvider.manifest.spec.source.directory.jsonnet.extVars[0].value'),
        cp.fromComposite('spec.parameters.region', 'spec.forProvider.manifest.spec.source.directory.jsonnet.extVars[1].value'),
        cp.fromComposite('spec.parameters.clusterName', 'spec.forProvider.manifest.spec.source.directory.jsonnet.extVars[2].value'),
        cp.fromComposite('status.outputs.clusterKubeconfig', 'spec.forProvider.manifest.spec.source.directory.jsonnet.extVars[3].value'),
      ]
    ),


    cp.object(
      'argo-app',
      argo.app(
        '',
        'argo',
        'git@github.com:blablabla/argocd',
        'argo-eks',
        vars=[
          {
            name: 'region',
          },
          {
            name: 'name',
          },
          {
            name: 'kubeconfig',
          },
          {
            name: 'endpoint',
          },
          {
            name: 'clusterCA',
          },
          {
            name: 'oidc',
          },
          {
            name: 'secretName',
          },
          {
            name: 'secretNamespce',
          },
          {
            name: 'account_id',
          },
          {
            name: 'amp_url',
          },
        ],
      ),
      [
        cp.combineFromComposite(
          [
            'spec.parameters.environment',
            'spec.parameters.region',
            'spec.parameters.clusterName',
          ],
          'eks-%s-%s-%s',
          'spec.forProvider.manifest.metadata.name',
        ),

        cp.fromComposite('spec.parameters.environment', 'spec.forProvider.manifest.spec.source.directory.jsonnet.extVars[0].value'),
        cp.fromComposite('spec.parameters.region', 'spec.forProvider.manifest.spec.source.directory.jsonnet.extVars[1].value'),
        cp.fromComposite('spec.parameters.clusterName', 'spec.forProvider.manifest.spec.source.directory.jsonnet.extVars[2].value'),
        cp.fromComposite('status.outputs.clusterKubeconfig', 'spec.forProvider.manifest.spec.source.directory.jsonnet.extVars[3].value'),
        cp.fromComposite('status.outputs.clusterEndpoint', 'spec.forProvider.manifest.spec.source.directory.jsonnet.extVars[4].value'),
        cp.fromComposite('status.outputs.clusterCA', 'spec.forProvider.manifest.spec.source.directory.jsonnet.extVars[5].value'),
        cp.fromComposite('status.outputs.eksOidc', 'spec.forProvider.manifest.spec.source.directory.jsonnet.extVars[6].value'),
        cp.fromComposite('spec.writeConnectionSecretToRef.name', 'spec.forProvider.manifest.spec.source.directory.jsonnet.extVars[7].value'),
        cp.fromComposite('spec.writeConnectionSecretToRef.namespace', 'spec.forProvider.manifest.spec.source.directory.jsonnet.extVars[8].value'),
        cp.fromComposite('spec.parameters.accountId', 'spec.forProvider.manifest.spec.source.directory.jsonnet.extVars[9].value'),
        cp.fromComposite('spec.parameters.ampUrl', 'spec.forProvider.manifest.spec.source.directory.jsonnet.extVars[10].value'),
      ]
    ),

  ]),
]

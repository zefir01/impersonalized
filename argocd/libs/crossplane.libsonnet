{
  local _controller_config(name, irsa_arn=null, fs_group=null, wave=null) = {
    apiVersion: 'pkg.crossplane.io/v1alpha1',
    kind: 'ControllerConfig',
    metadata: {
      name: name,
      annotations: {
        [if irsa_arn != null then 'eks.amazonaws.com/role-arn']: irsa_arn,
        [if wave != null then 'argocd.argoproj.io/sync-wave']: std.toString(wave),
        'argocd.argoproj.io/sync-options': 'SkipDryRunOnMissingResource=true',
      },
    },
    spec: {
      [if fs_group != null then 'podSecurityContext']: {
        fsGroup: fs_group,
      },
    },
  },
  controller_config:: _controller_config,

  local _provider(name, package, controller_config=null, wave=null) = {
    apiVersion: 'pkg.crossplane.io/v1',
    kind: 'Provider',
    metadata: {
      name: name,
      annotations: {
        [if wave != null then 'argocd.argoproj.io/sync-wave']: std.toString(wave),
        'argocd.argoproj.io/sync-options': 'SkipDryRunOnMissingResource=true',
      },
    },
    spec: {
      package: package,
      [if controller_config != null then 'controllerConfigRef']: {
        name: controller_config,
      },
    },
  },
  provider:: _provider,

  local _aws_provider_config(name, wave=null) = {
    apiVersion: 'aws.crossplane.io/v1beta1',
    kind: 'ProviderConfig',
    metadata: {
      name: name,
      annotations: {
        [if wave != null then 'argocd.argoproj.io/sync-wave']: std.toString(wave),
        'argocd.argoproj.io/sync-options': 'SkipDryRunOnMissingResource=true',
      },
    },
    spec: {
      credentials: {
        source: 'InjectedIdentity',
      },
    },
  },
  aws_provider_config:: _aws_provider_config,

  local _k8s_provider_config(name, wave=null, secretRef=null) = {
    apiVersion: 'kubernetes.crossplane.io/v1alpha1',
    kind: 'ProviderConfig',
    metadata: {
      name: name,
      annotations: {
        [if wave != null then 'argocd.argoproj.io/sync-wave']: std.toString(wave),
        'argocd.argoproj.io/sync-options': 'SkipDryRunOnMissingResource=true',
      },
    },
    spec: {
      credentials: {
        [if secretRef == null then 'source']: 'InjectedIdentity',
        [if secretRef != null then 'source']: 'secret',
        [if secretRef != null then 'secretRef']: secretRef,
      },
    },
  },
  k8s_provider_config:: _k8s_provider_config,

  local _helm_provider_config(name, wave=null, secretRef=null) = {
    apiVersion: 'helm.crossplane.io/v1beta1',
    kind: 'ProviderConfig',
    metadata: {
      name: name,
      annotations: {
        [if wave != null then 'argocd.argoproj.io/sync-wave']: std.toString(wave),
        'argocd.argoproj.io/sync-options': 'SkipDryRunOnMissingResource=true',
      },
    },
    spec: {
      credentials: {
        [if secretRef == null then 'source']: 'InjectedIdentity',
        [if secretRef != null then 'source']: 'secret',
        [if secretRef != null then 'secretRef']: secretRef,
      },
    },
  },
  helm_provider_config:: _helm_provider_config,
}
+
{
  local _combineFromComposite = function(fromFields, fmt, toField) {
    type: 'CombineFromComposite',
    combine: {
      variables: [
        {
          fromFieldPath: field,
        }
        for field in fromFields
      ],
      strategy: 'string',
      string: {
        fmt: fmt,
      },
    },
    toFieldPath: toField,
    policy: {
      fromFieldPath: 'Required',
    },
  },
  combineFromComposite:: _combineFromComposite,

  local _fromComposite = function(fromField, toFieldPath, transforms=null) {
    fromFieldPath: fromField,
    toFieldPath: toFieldPath,
    type: 'FromCompositeFieldPath',
    [if transforms != null then 'transforms']: transforms,
  },
  fromComposite:: _fromComposite,

  local _toComposite = function(fromField, toFieldPath, transforms=null) {
    type: 'ToCompositeFieldPath',
    fromFieldPath: fromField,
    toFieldPath: toFieldPath,
    [if transforms != null then 'transforms']: transforms,
  },
  toComposite:: _toComposite,

  local _strTransform = function(fmt) {
    type: 'string',
    string: {
      fmt: fmt,
    },
  },
  strTransform:: _strTransform,

  local _trimPrefixTransform = function(prefix) {
    type: 'string',
    string: {
      type: 'TrimPrefix',
      trim: prefix,
    },
  },
  trimPrefixTransform:: _trimPrefixTransform,

  local _fromBase64Transform = function() {
    type: 'string',
    string: {
      type: 'Convert',
      convert: 'FromBase64',
    },
  },
  fromBase64Transform:: _fromBase64Transform,

  local _toBase64Transform = function() {
    type: 'string',
    string: {
      type: 'Convert',
      convert: 'ToBase64',
    },
  },
  toBase64Transform:: _toBase64Transform,

  local _patchset = function(name) {
    type: 'PatchSet',
    patchSetName: name,
  },
  patchset:: _patchset,

  local _iamAttache = function(name, roleLabels=null, patches=[], policyLabels=null, policyArn=null, rolesMatchControllerRef=false, policiesMatchControllerRef=null) {
    name: name,
    base: {
      apiVersion: 'iam.aws.crossplane.io/v1beta1',
      kind: 'RolePolicyAttachment',
      spec: {
        forProvider: {
          roleNameSelector: if rolesMatchControllerRef then {
            matchControllerRef: true,
          }
          else {
            matchLabels: roleLabels,
          },
          [if policyLabels != null then 'policyArnSelector']: {
            matchLabels: policyLabels,
          },
          [if policyArn != null then 'policyArn']: policyArn,
          [if policiesMatchControllerRef != null then 'policyArnSelector']: {
            matchControllerRef: true,
          },
        },
      },
    },
    patches: patches,
  },
  iamAttache:: _iamAttache,

  local _role = function(name, labels=null, document=null, patches=[],) {
    name: name,
    base: {
      apiVersion: 'iam.aws.crossplane.io/v1beta1',
      kind: 'Role',
      [if labels != null then 'metadata']: {
        labels: labels,
      },
      spec: {
        forProvider: {
          [if document != null then 'assumeRolePolicyDocument']: document,
          tags: [
            {
              key: 'Name',
            },
          ],
        },
      },
    },
    patches: patches,
  },
  role:: _role,

  local _routeTable = function(name,
                               subnetLabels,
                               patches,
                               natGatewayLabels=null,
                               igwLabels=null,
                               vpcIdSelector={ matchControllerRef: true }) {
    name: name,
    base: {
      apiVersion: 'ec2.aws.crossplane.io/v1beta1',
      kind: 'RouteTable',
      spec: {
        forProvider: {
          vpcIdSelector: vpcIdSelector,
          routes: [
            {
              destinationCidrBlock: '0.0.0.0/0',
              [if natGatewayLabels != null then 'natGatewayIdSelector']: {
                matchLabels: natGatewayLabels,
              },
              [if igwLabels != null then 'gatewayIdSelector']: {
                matchLabels: igwLabels,
              },
            },
          ],
          associations: [
            {
              subnetIdSelector: {
                matchLabels: lab,
              },
            }
            for lab in subnetLabels
          ],
          tags: [
            {
              key: 'Name',
            },
          ],
        },
      },
    },
    patches: patches,
  },
  routeTable:: _routeTable,

  local _natGw = function(name, labels, allocationLabels, subnetLabels, patches, vpcIdSelector={ matchControllerRef: true }) {
    name: name,
    base: {
      apiVersion: 'ec2.aws.crossplane.io/v1beta1',
      kind: 'NATGateway',
      metadata: {
        labels: labels,
      },
      spec: {
        forProvider: {
          allocationIdSelector: {
            matchLabels: allocationLabels,
          },
          vpcIdSelector: vpcIdSelector,
          subnetIdSelector: {
            matchLabels: subnetLabels,
          },
          tags: [
            {
              key: 'Name',
            },
          ],
        },
      },
    },
    patches: patches,
  },
  natGw:: _natGw,

  local _eip = function(name, labels, patches) {
    name: name,
    base: {
      apiVersion: 'ec2.aws.crossplane.io/v1beta1',
      kind: 'Address',
      metadata: {
        labels: labels,
      },
      spec: {
        forProvider: {
          domain: 'vpc',
        },
      },
    },
    patches: patches,
  },
  eip:: _eip,

  local _subnet = function(name, labels, isPublic, tags, patches, vpcIdSelector={ matchControllerRef: true }) {
    name: name,
    base: {
      apiVersion: 'ec2.aws.crossplane.io/v1beta1',
      kind: 'Subnet',
      metadata: {
        labels: labels,
      },
      spec: {
        forProvider: {
          mapPublicIpOnLaunch: isPublic,
          vpcIdSelector: vpcIdSelector,
          tags: [
            {
              key: 'Name',
            },
          ] + tags,
        },
      },
    },
    patches: patches,
  },
  subnet:: _subnet,

  local _igw = function(name, labels, patches, tags=[], vpcIdSelector={ matchControllerRef: true }) {
    name: name,
    base: {
      apiVersion: 'ec2.aws.crossplane.io/v1beta1',
      kind: 'InternetGateway',
      metadata: {
        labels: labels,
      },
      spec: {
        forProvider: {
          vpcIdSelector: vpcIdSelector,
          tags: [
            {
              key: 'Name',
            },
          ] + tags,
        },
      },
    },
    patches: patches,
  },
  igw:: _igw,

  local _vpc = function(name, patches, tags=[]) {
    name: name,
    base: {
      apiVersion: 'ec2.aws.crossplane.io/v1beta1',
      kind: 'VPC',
      spec: {
        forProvider: {
          enableDnsSupport: true,
          enableDnsHostNames: true,
          tags: [
            {
              key: 'Name',
            },
          ] + tags,
        },
      },
    },
    patches: patches,
  },
  vpc:: _vpc,

  local _eks = function(name, subnetLabels, sgLabels, secretNs, secretName, patches, version='1.22') {
    name: name,
    base: {
      apiVersion: 'eks.aws.crossplane.io/v1beta1',
      kind: 'Cluster',
      spec: {
        forProvider: {
          resourcesVpcConfig: {
            endpointPrivateAccess: false,
            endpointPublicAccess: true,
            subnetIdSelector: {
              matchLabels: subnetLabels,
            },
            securityGroupIdSelector: {
              matchLabels: sgLabels,
            },
          },
          version: version,
        },
      },
    },
    patches: patches,
  },
  eks:: _eks,

  local _sg = function(name,
                       labels,
                       description,
                       patches,
                       ingress=[],
                       egress=[],
                       ingress_all=false,
                       egress_all=false,
                       vpcIdSelector={ matchControllerRef: true }) {
    local all = {
      fromPort: null,
      toPort: null,
      ipProtocol: '-1',
      ipRanges: [
        {
          cidrIp: '0.0.0.0/0',
        },
      ],
    },

    name: name,
    base: {
      apiVersion: 'ec2.aws.crossplane.io/v1beta1',
      kind: 'SecurityGroup',
      metadata: {
        labels: labels,
      },
      spec: {
        forProvider: {
          description: description,
          vpcIdSelector: vpcIdSelector,
          ingress: ingress + if ingress_all then [all] else [],
          egress: egress + if egress_all then [all] else [],
        },
      },
    },
    patches: patches + [
      _combineFromComposite(['metadata.name'], '%s-' + name, 'spec.forProvider.groupName'),
    ],
  },
  sg:: _sg,

  local _k8sPrividerConfig = function(name, patches)
    {
      name: name,
      base: {
        apiVersion: 'kubernetes.crossplane.io/v1alpha1',
        kind: 'ProviderConfig',
        spec: {
          credentials: {
            source: 'Secret',
            secretRef: {
              key: 'kubeconfig',
            },
          },
        },
      },
      patches: patches,
    },
  k8sPrividerConfig:: _k8sPrividerConfig,

  local _object = function(name, manifest, patches, managementPolicy='Default', references=null) {
    name: name,
    base: {
      apiVersion: 'kubernetes.crossplane.io/v1alpha1',
      kind: 'Object',
      spec: {
        managementPolicy: managementPolicy,
        forProvider: {
          manifest: manifest,
        },
        [if references != null then 'references']: references,
      },
    },
    patches: patches,
  },
  object:: _object,

  local _launchTemplate = function(name, patches) {

    name: name,
    base: {
      apiVersion: 'ec2.aws.crossplane.io/v1alpha1',
      kind: 'LaunchTemplate',
      spec: {
        forProvider: {
          //launchTemplateName: name+"-"+stack
        },
      },
    },
    patches: patches,
  },
  launchTemplate:: _launchTemplate,

  local _policy = function(name, patches, document=null) {
    name: name,
    base: {
      apiVersion: 'iam.aws.crossplane.io/v1beta1',
      kind: 'Policy',
      spec: {
        forProvider: {
          [if document != null then 'document']: document,
        },
      },
    },
    patches: patches + [
      _fromComposite(
        'metadata.uid',
        'spec.forProvider.name',
        [_strTransform('%s-' + name)]
      ),
    ],
  },
  policy:: _policy,

  local _eksImport = function(name, patches=[]) {
    name: 'eks-' + name,
    base: {
      apiVersion: 'eks.aws.crossplane.io/v1beta1',
      kind: 'Cluster',
      //            metadata: {
      //                annotations:{
      //                    "crossplane.io/external-name": name
      //                },
      //            },
      spec: {
        deletionPolicy: 'Orphan',
        forProvider: {
          resourcesVpcConfig: {},
        },
      },
    },
    patches: [
      _fromComposite(
        'metadata.uid',
        'spec.writeConnectionSecretToRef.name',
        transforms=[
          _strTransform('%s-eks-' + name),
        ]
      ),
      _toComposite('spec.writeConnectionSecretToRef.name', 'status.outputs.eks-' + name + '-secretName'),
      _fromComposite('spec.writeConnectionSecretToRef.namespace', 'spec.writeConnectionSecretToRef.namespace'),
    ] + patches,
    connectionDetails: [
      {
        name: name + '-clusterCA',
        fromConnectionSecretKey: 'clusterCA',
      },
      {
        name: name + '-endpoint',
        fromConnectionSecretKey: 'endpoint',
      },
      {
        name: name + '-kubeconfig',
        fromConnectionSecretKey: 'kubeconfig',
      },
    ],
  },
  eksImport:: _eksImport,

  local _xrd = function(name, domain, params=null) {
    local field = function(field) {
      [field]: {
        type: 'string',
      },
    },

    apiVersion: 'apiextensions.crossplane.io/v1',
    kind: 'CompositeResourceDefinition',
    metadata: {
      name: name + '.' + domain,
    },
    spec: {
      group: domain,
      names: {
        kind: std.asciiUpper(std.substr(name, 0, 1)) + std.substr(name, 1, std.length(name) - 1),
        plural: name,
      },
      versions: [
        {
          name: 'v1beta1',
          served: true,
          referenceable: true,
          schema: {
            openAPIV3Schema: {
              type: 'object',
              properties: {
                spec: {
                  type: 'object',
                  properties: {
                    parameters: {
                      type: 'object',
                      properties: {
                        region: {
                          description: 'EKS region',
                          type: 'string',
                        },
                        awsProviderConfig: {
                          type: 'string',
                          default: 'aws-provider',
                        },

                      } + if params != null then params else {},
                      required: [
                                  'region',
                                ] +
                                [
                                  n
                                  for n in std.filter(function(p) !std.objectHasAll(params[p], 'default'), std.objectFields(params))
                                ],
                    },
                  },
                  required: [
                    'parameters',
                  ],
                },
                status: {
                  type: 'object',
                  properties: {
                    outputs: {
                      type: 'object',
                      'x-kubernetes-preserve-unknown-fields': true,
                    },
                  },
                },
              },
            },
          },
        },
      ],
    },
  },
  xrd:: _xrd,

  local _comp = function(name, domain, resources) {
    local awsCommonPatchset = _patchset('aws-common-parameters'),

    apiVersion: 'apiextensions.crossplane.io/v1',
    kind: 'Composition',
    metadata: {
      name: name,
    },
    spec: {
      writeConnectionSecretsToNamespace: 'crossplane-system',
      compositeTypeRef: {
        apiVersion: domain + '/v1beta1',
        kind: std.asciiUpper(std.substr(name, 0, 1)) + std.substr(name, 1, std.length(name) - 1),
      },
      patchSets: [
        {
          name: 'aws-common-parameters',
          patches: [
            {
              fromFieldPath: 'spec.parameters.region',
              toFieldPath: 'spec.forProvider.region',
            },
            {
              fromFieldPath: 'spec.parameters.awsProviderConfig',
              toFieldPath: 'spec.providerConfigRef.name',
            },
          ],
        },
      ],
      resources: [res {
        patches: if std.endsWith(res.base.apiVersion, 'aws.crossplane.io/v1beta1') then
          if std.objectHas(res, 'patches') then res.patches + [awsCommonPatchset] else [awsCommonPatchset]
        else res.patches,
        base: if std.objectHas(res.base, 'metadata') then res.base
                                                          {
          [if std.prune(res.base.metadata) == {} then 'metadata']:: {},
          [if std.prune(res.base.metadata) != {} then 'metadata']: std.prune(res.base.metadata),
        } else res.base,
      } for res in resources],
    },
  },
  comp:: _comp,

  local _claim = function(name, kind, domain, params={}) {
    apiVersion: domain + '/v1beta1',
    kind: std.asciiUpper(std.substr(kind, 0, 1)) + std.substr(kind, 1, std.length(kind) - 1),
    metadata: {
      name: name,
    },
    spec: {
      parameters: params,
      compositionRef: {
        name: kind,
      },
    },
  },
  claim:: _claim,

  local _eksImportK8sProviderConfig(name, eksName) = {
    name: name,
    base: {
      apiVersion: 'kubernetes.crossplane.io/v1alpha1',
      kind: 'ProviderConfig',
      spec: {
        credentials: {
          source: 'Secret',
          secretRef: {
            key: 'kubeconfig',
            namespace: '',
            name: '',

          },
        },
      },
    },
    patches: [
      _fromComposite('status.outputs.eks-' + eksName + '-secretName', 'spec.credentials.secretRef.name'),
      _fromComposite('spec.writeConnectionSecretToRef.namespace', 'spec.credentials.secretRef.namespace'),
      _toComposite('metadata.name', 'status.outputs.' + name + '.name'),
    ],
    readinessChecks: [
      {
        type: 'None',
      },
    ],
  },
  eksImportK8sProviderConfig:: _eksImportK8sProviderConfig,

  local _eksImportHelmProviderConfig(name, eksName) = {
    name: name,
    base: {
      apiVersion: 'helm.crossplane.io/v1beta1',
      kind: 'ProviderConfig',
      spec: {
        credentials: {
          source: 'Secret',
          secretRef: {
            key: 'kubeconfig',
            namespace: '',
            name: '',

          },
        },
      },
    },
    patches: [
      _fromComposite('status.outputs.eks-' + eksName + '-secretName', 'spec.credentials.secretRef.name'),
      _fromComposite('spec.writeConnectionSecretToRef.namespace', 'spec.credentials.secretRef.namespace'),
      _toComposite('metadata.name', 'status.outputs.' + name + '.name'),
    ],
    readinessChecks: [
      {
        type: 'None',
      },
    ],
  },
  eksImportHelmProviderConfig:: _eksImportHelmProviderConfig,

  local _helm = function(name, chartName, chartRepo, chartVersion, values, patches) {
    name: name,
    base: {
      apiVersion: 'helm.crossplane.io/v1beta1',
      kind: 'Release',
      spec: {
        forProvider: {
          chart: {
            name: chartName,
            repository: chartRepo,
            version: chartVersion,
          },
          values: values,
        },
      },
    },
    patches: patches,
  },
  helm:: _helm,

}

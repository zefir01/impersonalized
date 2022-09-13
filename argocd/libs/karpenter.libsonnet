{
  local _provisioner = function(name, taintKey, taintValue, clusterName) {
    apiVersion: 'karpenter.sh/v1alpha5',
    kind: 'Provisioner',
    metadata: {
      name: name,
    },
    spec: {
      taints: [
        {
          key: taintKey,
          value: taintValue,
          effect: 'NoSchedule',
        },
        {
          key: taintKey,
          value: taintValue,
          effect: 'NoExecute',
        },
      ],
      limits: {
        resources: {
          cpu: '4',
        },
      },
      requirements: [
        {
          key: 'karpenter.sh/capacity-type',
          operator: 'In',
          values: [
            'spot',
            'on-demand',
          ],
        },
        {
          key: 'kubernetes.io/arch',
          operator: 'In',
          values: [
            'amd64',
          ],
        },
      ],
      provider: {
        metadataOptions: {
          httpEndpoint: 'enabled',
          httpProtocolIPv6: 'disabled',
          httpPutResponseHopLimit: 64,
          httpTokens: 'optional',
        },
        subnetSelector: {
          ['kubernetes.io/cluster/' + clusterName]: '*',
          type: 'private',
        },
        securityGroupSelector: {
          ['kubernetes.io/cluster/' + clusterName]: 'node',
        },
      },
      ttlSecondsAfterEmpty: 30,
    },
  },
  provisioner:: _provisioner,
}

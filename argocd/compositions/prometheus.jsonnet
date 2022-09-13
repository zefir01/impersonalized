local argo = import '../libs/argo.libsonnet';
local cp = import '../libs/crossplane.libsonnet';

local domain = std.extVar('domain');

local var = function(name, value) {
  name: name,
  value: value,
};


[
  cp.xrd(
    'prometheus',
    domain,
    params={
      accountId: {
        type: 'string',
      },
      ampUrl: {
        type: 'string',
      },
      targetNamespace: {
        type: 'string',
      },
      eksOidc: {
        type: 'string',
      },
      clusterName: {
        type: 'string',
      },
      clusterEndpoint: {
        type: 'string',
      },
    },
  ),

  cp.comp('prometheus', domain, [

    cp.policy(
      'irsa-policy',
      [
        cp.fromComposite(
          'metadata.uid',
          'metadata.labels.composition'
        ),
      ],
      document=|||
        {
            "Version": "2012-10-17",
            "Statement": [
                {"Effect": "Allow",
                    "Action": [
                        "aps:RemoteWrite",
                        "aps:QueryMetrics",
                        "aps:GetSeries",
                        "aps:GetLabels",
                        "aps:GetMetricMetadata"
                    ],
                    "Resource": "*"
                }
            ]
        }
      |||
    ),
    {
      name: 'irsa',
      base:
        {
          apiVersion: domain + '/v1beta1',
          kind: 'Irsa',
          spec: {
            parameters: {
              saName: 'prometheus-server',
            },
            compositionRef: {
              name: 'irsa',
            },
          },
        },
      patches: [
        cp.fromComposite(
          'spec.parameters.targetNamespace',
          'spec.parameters.saNamespace'
        ),
        cp.fromComposite(
          'metadata.uid',
          'spec.parameters.policyLabels.composition'
        ),
        cp.fromComposite(
          'spec.parameters.accountId',
          'spec.parameters.accountId'
        ),
        cp.fromComposite(
          'spec.parameters.region',
          'spec.parameters.region'
        ),
        cp.fromComposite(
          'spec.parameters.eksOidc',
          'spec.parameters.eksOidc'
        ),
        cp.toComposite(
          'status.outputs.roleArn',
          'status.outputs.irsaArn'
        ),
      ],
    },

    cp.object(
      'prometheus-crds',
      argo.appKustomize(
        '',
        '',
        'git@github.com:blablabla/argocd',
        'apps/prometheus-crds',
        replace=true,
        applyOutOfSyncOnly=true,
        wave=10,
        dest_k8s=''
      ),
      patches=[
        cp.fromComposite(
          'spec.parameters.clusterEndpoint',
          'spec.forProvider.manifest.spec.destination.server'
        ),
        cp.fromComposite(
          'spec.parameters.targetNamespace',
          'spec.forProvider.manifest.spec.destination.namespace'
        ),
      ],
    ),

    cp.object(
      'metrics-server',
      argo.app_helm(
        '',
        '',
        'https://charts.bitnami.com/bitnami',
        'metrics-server',
        '6.0.0',
        helm_params=[
          var('replicas', '1'),
        ],
        wave=10,
        dest_k8s=''
      ),
      patches=[
        cp.fromComposite(
          'spec.parameters.clusterEndpoint',
          'spec.forProvider.manifest.spec.destination.server'
        ),
        cp.fromComposite(
          'spec.parameters.targetNamespace',
          'spec.forProvider.manifest.spec.destination.namespace'
        ),
      ],
    ),


    cp.object(
      'argo-helm',
      argo.app_helm(
        '',
        '',
        'https://prometheus-community.github.io/helm-charts',
        'kube-prometheus-stack',
        '35.0.3',
        wave=20,
        dest_k8s='',
        helm_params=[
          var('kubeApiServer.enabled', 'false'),
          {
            name: 'prometheus.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn',
          },
          var('prometheus.serviceAccount.name', 'prometheus-server'),
          var('grafana.enabled', 'false'),
          var('alertmanager.enabled', 'false'),
          {
            name: 'prometheus.prometheusSpec.remoteWrite[0].url',
          },
          {
            name: 'prometheus.prometheusSpec.remoteWrite[0].sigv4.region',
          },
          var('prometheus.prometheusSpec.remoteWrite[0].writeRelabelConfigs[0].targetLabel', 'cluster_name'),
          {
            name: 'prometheus.prometheusSpec.remoteWrite[0].writeRelabelConfigs[0].replacement',
          },
          var('prometheus.prometheusSpec.retention', '3h'),

          var('prometheus.prometheusSpec.resources.requests.cpu', '10m'),
          var('prometheus.prometheusSpec.resources.requests.memory', '128Mi'),

          var('prometheusOperator.prometheusConfigReloader.resources.requests.cpu', '10m'),
          //var("prometheusOperator.prometheusConfigReloader.resources.requests.memory", "128Mi"),

          var('prometheusOperator.admissionWebhooks.patch.resources.requests.cpu', '10m'),
          var('prometheusOperator.admissionWebhooks.patch.resources.requests.memory', '128Mi'),

          var('prometheusOperator.resources.requests.cpu', '10m'),
          var('prometheusOperator.resources.requests.memory', '128Mi'),

          var('prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues', 'false'),
          var('prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues', 'false'),
        ],
        skipCrds=true,
        selfHeal=false,
        ignoreDifferences=[
          {
            group: 'admissionregistration.k8s.io',
            kind: 'MutatingWebhookConfiguration',
            //name: 'prometheus-operator-kube-p-admission',
            jqPathExpressions: [
              '.webhooks[0].failurePolicy',
            ],
          },
          {
            group: 'admissionregistration.k8s.io',
            kind: 'ValidatingWebhookConfiguration',
            //name: 'prometheus-operator-kube-p-admission',
            jqPathExpressions: [
              '.webhooks[0].failurePolicy',
            ],
          },
        ],
      ),
      patches=[
        cp.fromComposite(
          'status.outputs.irsaArn',
          'spec.forProvider.manifest.spec.source.helm.parameters[1].value'
        ),
        cp.fromComposite(
          'spec.parameters.ampUrl',
          'spec.forProvider.manifest.spec.source.helm.parameters[5].value',
          transforms=[
            cp.strTransform('%sapi/v1/remote_write'),
          ],
        ),
        cp.fromComposite(
          'spec.parameters.region',
          'spec.forProvider.manifest.spec.source.helm.parameters[6].value'
        ),
        cp.fromComposite(
          'spec.parameters.clusterName',
          'spec.forProvider.manifest.spec.source.helm.parameters[8].value'
        ),
        cp.fromComposite(
          'spec.parameters.clusterEndpoint',
          'spec.forProvider.manifest.spec.destination.server'
        ),
        cp.fromComposite(
          'spec.parameters.targetNamespace',
          'spec.forProvider.manifest.spec.destination.namespace'
        ),
      ],
    ),


  ]),
]

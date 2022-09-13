{
    apiVersion: "blablabla.org/v1beta1",
    kind: "Network",
    metadata: {
        name: "test-network",
        annotations: {
            "argocd.argoproj.io/sync-wave": "300",
            "argocd.argoproj.io/sync-options": "SkipDryRunOnMissingResource=true"
        }
    },
    spec: {
        parameters: {
            region: "eu-central-1",
            "vpc-name": "EKS-CROSSPLANE-ARGOCD-VPC",
            "vpc-cidrBlock": "192.168.48.0/20",
            "subnet1-public-name": "PUBLIC-WORKER-1",
            "subnet1-public-cidrBlock": "192.168.48.0/24",
            "subnet2-public-name": "PUBLIC-WORKER-2",
            "subnet2-public-cidrBlock": "192.168.49.0/24",
            "subnet1-private-name": "PRIVATE-WORKER-1",
            "subnet1-private-cidrBlock": "192.168.50.0/24",
            "subnet2-private-name": "PRIVATE-WORKER-2",
            "subnet2-private-cidrBlock": "192.168.51.0/24",
            awsProviderConfig: "aws-provider",
            eksSecretName: "eks-test",
            eksSecretNamespace: "default"
        },
        compositionRef: {
            name: "network"
        },
        writeConnectionSecretToRef: {
            namespace: "default",
            name: "crossplane-argocd-cluster-connection"
        }
    }
}
#https://github.com/aws-samples/eks-gitops-crossplane-argocd/blob/main/crossplane-imperative/eks-configuration/composition.yaml
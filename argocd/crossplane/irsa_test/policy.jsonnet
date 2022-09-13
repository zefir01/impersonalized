local policy = function(stack, name, document, labels, description=null){
    apiVersion: "iam.aws.crossplane.io/v1beta1",
    kind: "Policy",
    metadata: {
        name: stack+"-"+name,
    },
    spec: {
        forProvider: {
            description: if description==null then stack+"-"+name else description,
            name: stack+"-"+name,
            document: document,
        },
        providerConfigRef: {
            name: "aws-provider"
        },
    }
};

policy("main", "irsa-test", |||
    {
        "Version": "2012-10-17",
        "Statement": [
            {"Effect": "Allow",
                "Action": [
                "aps:RemoteWrite",
                "aps:GetSeries",
                "aps:GetLabels",
                "aps:GetMetricMetadata",

                "aps:QueryMetrics",
                "aps:GetSeries",
                "aps:GetLabels",
                "aps:GetMetricMetadata"
                ],
                "Resource": "*"
            }
        ]
    }
|||,
    {
        app: "test1"
    },
)
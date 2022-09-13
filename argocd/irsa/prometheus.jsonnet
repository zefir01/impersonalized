local policy = import "policy.libsonnet";
local cp = import "../libs/crossplane.libsonnet";

local stack = std.extVar("stack");
local domain = std.extVar("domain");

[
    policy(stack, "prometheus-irsa", |||
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
            app: "prometheus-irsa"
        },
    ),

    cp.claim("prometheus-irsa", "irsa-sa", domain, 
        params={
            region: "eu-central-1",
            clusterName: "main",
            awsProviderConfig: "aws-provider",
            saNamespace: "prometheus",
            saName: "prometheus-server",
            policyLabels: {
                app: "prometheus-irsa"
            },
        }
    )
]
local obj=import "object.libsonnet";

function(arn, stack, provider) obj(provider, "aws-auth", stack, {
        "apiVersion": "v1",
        "data": {
            mapUsers: std.format(|||
        - userarn: %s
          username: admin
          groups:
            - system:masters
    |||, arn)
        },
        "kind": "ConfigMap",
        "metadata": {
            "name": "aws-auth",
            "namespace": "kube-system",
        }
    }
)
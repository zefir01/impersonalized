local k8s = import "k8s.libsonnet";

function(name, esEndpoint, esUsername, esPassword, namespace, wave=null)[
    k8s.secret("jaeger-"+name+"-elasticserach-creds", {
        ES_PASSWORD: std.base64(esPassword),
        ES_USERNAME: std.base64(esUsername)
    }, namespace=namespace, wave=wave),

    {
        apiVersion: "jaegertracing.io/v1",
        kind: "Jaeger",
        metadata: {
            name: name,
            namespace: namespace,
            [if wave!=null then "annotations"]: {
                "argocd.argoproj.io/sync-wave": std.toString(wave)
            },
        },
        spec: {
            strategy: "production",
            ingress: {
                enabled: false
            },
            storage: {
                type: "elasticsearch",
                options: {
                    es: {
                        "server-urls": esEndpoint,
                        "index-prefix": "jaeger",
                    }
                },
                secretName: "jaeger-"+name+"-elasticserach-creds"
            }
        }
    }
]
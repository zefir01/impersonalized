function(name, sa, s3_bucket_name, kms_key_id, region, irsa_arn, table_name){
    apiVersion: "vault.banzaicloud.com/v1alpha1",
    kind: "Vault",
    metadata: {
        name: name
    },
    spec: {
        serviceAccount: sa,
        size: 1,
        image: "vault:1.6.2",
        bankVaultsImage: "banzaicloud/bank-vaults:latest",
        resources:{
            vault:{
                requests:{
                    cpu: "10m",
                    memory: "128Mi"
                },
                limits:{
                    cpu: "100m",
                    memory: "256Mi"
                },
            },
        },
        vaultConfigurerAnnotations: {
            "eks.amazonaws.com/role-arn": irsa_arn
        },
        vaultEnvsConfig:[
            {
                name: "VAULT_LOG_LEVEL",
                value: "debug"
            },
        ],
        unsealConfig: {
            options:{
                preFlightChecks: true,
                storeRootToken: true
            },
            aws: {
                kmsKeyId: kms_key_id,
                kmsRegion: region,
                s3Bucket: s3_bucket_name,
                s3Prefix: "vault-operator/",
                s3Region: region
            }
        },
        config: {
            storage: {
                /*
                s3: {
                    region: region,
                    bucket: s3_bucket_name,
                    ha_enabled: "false",
                },
                */
                dynamodb:{
                    ha_enabled: "true",
                    region: region,
                    table: table_name
                },
            },
            listener: {
                tcp: {
                    address: "0.0.0.0:8200",
                    tls_cert_file: "/vault/tls/server.crt",
                    tls_key_file: "/vault/tls/server.key"
                }
            },
            
            seal: {
                awskms: {
                    region: region,
                    kms_key_id: kms_key_id
                },
            },
             
            api_addr: "https://"+name+":8200",
            telemetry:{
                statsd_address: "localhost:9125"
            },
            ui: true
        },
        externalConfig: {
            policies: [
                {
                    name: "allow_secrets",
                    rules: "path \"secret/*\" { capabilities = [\"create\", \"read\", \"update\", \"delete\", \"list\"] }"
                }
            ],
            auth: [
                {
                    type: "kubernetes",
                    roles: [
                        {
                            name: "default",
                            bound_service_account_names: "default",
                            bound_service_account_namespaces: "default",
                            policies: "allow_secrets",
                            ttl: "1h"
                        }
                    ]
                }
            ]
        }
    }
}
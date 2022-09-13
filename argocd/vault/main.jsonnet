local vault = import "vault.libsonnet";
local k8s = import "../libs/k8s.libsonnet";
local prom = import "../libs/prometheus.libsonnet";

local vault_irsa_arn = std.extVar("vault_irsa_arn");
local vault_s3_bucket_name = std.extVar("vault_s3_bucket_name");
local vault_kms_key_id = std.extVar("vault_kms_key_id");
local vault_sa_name = std.extVar("vault_sa_name");
local vault_sa_namespace = std.extVar("vault_sa_namespace");
local region = std.extVar("region");
local table_name = std.extVar("vault_table_name");

[
    k8s.sa(vault_sa_name, irsa_arn=vault_irsa_arn),
    k8s.role(vault_sa_name, [
        {
            apiGroups: [
                ""
            ],
            resources: [
                "secrets"
            ],
            verbs: [
                "*"
            ]
        },
        {
            apiGroups: [
                ""
            ],
            resources: [
                "pods"
            ],
            verbs: [
                "get",
                "update",
                "patch"
            ]
        }
    ]),
    k8s.roleBinding(vault_sa_name, vault_sa_name, vault_sa_name),
    k8s.clusterRoleBinding(vault_sa_name, "system:auth-delegator", vault_sa_name, vault_sa_namespace),
    vault("vault", vault_sa_name, vault_s3_bucket_name, vault_kms_key_id, region, vault_irsa_arn, table_name),
    prom.serviceMonitor("vault", {"app.kubernetes.io/name": "vault"}, "metrics"),
    prom.serviceMonitor("vault-configurator", {"app.kubernetes.io/name": "vault-configurator"}, "metrics")
]
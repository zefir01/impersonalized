local argo = import "../../libs/argo.libsonnet";
local jaeger = import "../../libs/jaeger.libsonnet";

local es_username = std.extVar("es_username");
local es_password = std.extVar("es_password");
local es_endpoint = std.extVar("es_endpoint");

[
    argo.app_helm("jaeger-operator", "jaeger", "https://jaegertracing.github.io/helm-charts", 
        "jaeger-operator", "2.29.0", wave=10),
] + jaeger("main", "https://"+es_endpoint+":443", es_username, es_password, "jaeger", wave=20)
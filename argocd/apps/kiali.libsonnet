local argo = import "../libs/argo.libsonnet";
local var=function(name, value){
    name: name,
    value: value
};

function() argo.app_helm("istio-kiali", "istio-system", "https://kiali.org/helm-charts",
    "kiali-server", "1.50",
    helm_params=[
        var("deployment.ingress.class_name", "alb"),
        var("auth.strategy", "token")
    ], wave=10, selfHeal=false
)
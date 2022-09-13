local argo = import "../libs/argo.libsonnet";

local var=function(name, value){
    name: name,
    value: value
};
#https://github.com/newrelic/newrelic-istio-adapter/blob/master/helm-charts/README.md#configuration

function()[
    argo.app_helm("newrelic", "newrelic", "https://helm-charts.newrelic.com",
        "nri-bundle", "4.3.2",
        helm_params=[
            var("global.licenseKey", "eu01xx70d1b9bf3bfcb59ba3133c2c4a45bdNRAL"),
            var("global.cluster", "main"),
            var("newrelic-infrastructure.privileged", "true"),
            var("ksm.enabled", "true"),
            var("kubeEvents.enabled", "true"),
            var("prometheus.enabled", "true"),
            var("logging.enabled", "true"),

            var("kube-state-metrics.resources.requests.cpu", "10m"),
            var("kube-state-metrics.resources.requests.memory", "128Mi"),

            var("nri-kube-events.resources.requests.cpu", "10m"),
            var("nri-kube-events.resources.requests.memory", "128Mi"),

            var("nri-prometheus.resources.requests.cpu", "10m"),
            var("nri-prometheus.resources.requests.memory", "128Mi"),

            var("newrelic-logging.resources.requests.cpu", "10m"),
            var("newrelic-logging.resources.requests.memory", "128Mi"),

            var("newrelic-infrastructure.ksm.resources.requests.cpu", "10m"),
            var("newrelic-infrastructure.ksm.resources.requests.memory", "128Mi"),

            var("newrelic-infrastructure.controlPlane.resources.requests.cpu", "10m"),
            var("newrelic-infrastructure.controlPlane.resources.requests.memory", "128Mi"),

            var("newrelic-infrastructure.kubelet.resources.requests.cpu", "10m"),
            var("newrelic-infrastructure.kubelet.resources.requests.memory", "128Mi"),
            
        ], wave=10, selfHeal=false
    ),
    argo.app_helm("newrelic-istio-adapter", "newrelic", "https://github.com/newrelic/newrelic-istio-adapter.git",
        "helm-charts", "2.0.3",
        helm_params=[
            var("authentication.apiKey", "eu01xx70d1b9bf3bfcb59ba3133c2c4a45bdNRAL")
        ], wave=10
    ),
]
local argo = import "../libs/argo.libsonnet";
local var=function(name, value){
    name: name,
    value: value
};


function(es_username, es_password, es_endpoint) argo.app("jaeger", "jaeger", "git@github.com:blablabla/argocd", "apps/jaeger", options={
    directory: {
        jsonnet: {
            extVars: [
                var("es_username", es_username),
                var("es_password", es_password),
                var("es_endpoint", es_endpoint)
            ]
        }
    }
}, wave=10)
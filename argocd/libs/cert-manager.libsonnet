{
    local _cert=function(name, secretName, commonName, namespace=null, dnsNames=null, issuer=null, wave=null){
        apiVersion: "cert-manager.io/v1",
        kind: "Certificate",
        metadata: {
            name: name,
            [if namespace!=null then "namespace"]: namespace,
            [if wave!=null then "annotations"]: {
                "argocd.argoproj.io/sync-wave": std.toString(wave)
            }
        },
        spec: {
            secretName: secretName,
            commonName: commonName,
            [if dnsNames!=null then "dnsNames"]: dnsNames,
            privateKey: {
                rotationPolicy: "Always"
            },
            issuerRef: if issuer!=null then issuer else {
                name: "selfsigned-cluster-issuer",
                kind: "ClusterIssuer",
                group: "cert-manager.io"
            }
        }
    },
    cert:: _cert,

    local _selfSignedClusterIssuer = function(name="selfsigned-cluster-issuer", wave=null, skipDryRun=false){
        apiVersion: "cert-manager.io/v1",
        kind: "ClusterIssuer",
        metadata: {
            name: name,
            annotations:{
                [if wave!=null then "argocd.argoproj.io/sync-wave"]: std.toString(wave),
                [if skipDryRun then "argocd.argoproj.io/sync-options"]: "SkipDryRunOnMissingResource=true"
            },
        },
        spec: {
            selfSigned: {}
        }
    },
    selfSignedClusterIssuer:: _selfSignedClusterIssuer
}
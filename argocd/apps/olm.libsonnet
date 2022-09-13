local argo = import "../libs/argo.libsonnet";

function()[
    argo.app("olm", "operator-lifecycle-manager", "https://github.com/operator-framework/operator-lifecycle-manager.git",
        "deploy/chart", targetRevision="v0.21.2",

        wave=20,
        skipCrds=true,
        skipDryRun=true
    ),
    argo.app("olm-crds", "operator-lifecycle-manager", "git@github.com:blablabla/argocd", "apps/olm-crds",
        replace=true, applyOutOfSyncOnly=true, wave=10),
]
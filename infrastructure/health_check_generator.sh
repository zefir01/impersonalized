#!/bin/bash

#./health_check_generator.sh | kubectl apply -f -

LIST=$(kubectl get crds -o=custom-columns=KIND:.spec.names.kind -o=custom-columns=KIND:.spec.names.kind,GROUP:.spec.group | grep 'crossplane.io\|blablabla.org' | grep -v "CompositeResourceDefinition\|Composition\|ProviderConfig\|Provider\|ProviderConfigUsage\|pkg.crossplane.io" | awk '{print $2"_"$1}')
FIRST=$(echo "$LIST" | head -n1)

cat <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  annotations:
    meta.helm.sh/release-name: argo-cd
    meta.helm.sh/release-namespace: argo
  labels:
    app.kubernetes.io/component: server
    app.kubernetes.io/instance: argo-cd
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: argocd-cm
    app.kubernetes.io/part-of: argocd
    helm.sh/chart: argo-cd-4.5.1
  name: argocd-cm
  namespace: argo
data:
  accounts.alice: apiKey,login
  application.instanceLabelKey: argocd.argoproj.io/instance
EOF
for i in $LIST
do
  echo "  resource.customizations.health.$i: |"
cat <<EOF
    hs = {
      status = "Progressing",
      message = "Waiting resource to be installed"
    }
    if obj.status ~= nil then
      if obj.status.conditions ~= nil then
        for i, condition in ipairs(obj.status.conditions) do
          if condition.type == "Ready" then
            hs.message = condition.reason
            if condition.status == "True" then
              hs.status = "Healthy"
              return hs
            end
          end
        end
      end
    end
    return hs
EOF
done
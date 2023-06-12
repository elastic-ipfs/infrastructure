#!/bin/bash

YOUR_ARGOCD_NAMESPACE="argocd" # e.g. argo-cd
YOUR_ARGOCD_RELEASENAME="argocd-apps" # e.g. argo-cd

for crd in "applications.argoproj.io" "applicationsets.argoproj.io" "argocdextensions.argoproj.io" "appprojects.argoproj.io"; do
  kubectl label --overwrite crd $crd app.kubernetes.io/managed-by=Helm
  kubectl annotate --overwrite crd $crd meta.helm.sh/release-namespace="$YOUR_ARGOCD_NAMESPACE"
  kubectl annotate --overwrite crd $crd meta.helm.sh/release-name="$YOUR_ARGOCD_RELEASENAME"
done

#!/bin/bash

YOUR_ARGOCD_NAMESPACE="argocd" # e.g. argo-cd
YOUR_ARGOCD_RELEASENAME="argocd-apps" # e.g. argo-cd

for crd in "applications.argoproj.io" "applicationsets.argoproj.io" "argocdextensions.argoproj.io" "appprojects.argoproj.io"; do
  kubectl label --overwrite crd $crd app.kubernetes.io/managed-by=Helm
  kubectl annotate --overwrite crd $crd meta.helm.sh/release-namespace="$YOUR_ARGOCD_NAMESPACE"
  kubectl annotate --overwrite crd $crd meta.helm.sh/release-name="$YOUR_ARGOCD_RELEASENAME"
done

for sa in "argocd-notifications-controller"; do
  kubectl -n $YOUR_ARGOCD_NAMESPACE label --overwrite serviceaccount $sa app.kubernetes.io/managed-by=Helm
  kubectl -n $YOUR_ARGOCD_NAMESPACE annotate --overwrite serviceaccount $sa meta.helm.sh/release-namespace="$YOUR_ARGOCD_NAMESPACE"
  kubectl -n $YOUR_ARGOCD_NAMESPACE annotate --overwrite serviceaccount $sa meta.helm.sh/release-name="$YOUR_ARGOCD_RELEASENAME"
done

for sec in "argocd-notifications-secret"; do
  kubectl -n $YOUR_ARGOCD_NAMESPACE label --overwrite secret $sec app.kubernetes.io/managed-by=Helm
  kubectl -n $YOUR_ARGOCD_NAMESPACE annotate --overwrite secret $sec meta.helm.sh/release-namespace="$YOUR_ARGOCD_NAMESPACE"
  kubectl -n $YOUR_ARGOCD_NAMESPACE annotate --overwrite secret $sec meta.helm.sh/release-name="$YOUR_ARGOCD_RELEASENAME"
done

for cm in "argocd-notifications-cm"; do
  kubectl -n $YOUR_ARGOCD_NAMESPACE label --overwrite configmap $cm app.kubernetes.io/managed-by=Helm
  kubectl -n $YOUR_ARGOCD_NAMESPACE annotate --overwrite configmap $cm meta.helm.sh/release-namespace="$YOUR_ARGOCD_NAMESPACE"
  kubectl -n $YOUR_ARGOCD_NAMESPACE annotate --overwrite configmap $cm meta.helm.sh/release-name="$YOUR_ARGOCD_RELEASENAME"
done

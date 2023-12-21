#!/bin/bash
set -x
# https://blog.sean-wright.com/self-host-acme-server/
#
#
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml

sops -d cert-manager-cluster-issuer-secrets.yaml | kubectl apply -f -

kubectl create namespace argocd

#curl -qs 'https://raw.githubusercontent.com/argoproj/argo-cd/v2.6.15/manifests/install.yaml' | sed 's#quay.io/argoproj/argocd:v2.6.15#ghcr.io/halkeye/docker-argocd:sha-5ab90bc#g' | kubectl apply -n argocd -f -
curl -qs 'https://raw.githubusercontent.com/argoproj/argo-cd/v2.6.15/manifests/install.yaml' | kubectl apply -n argocd -f -
kubectl apply -n argocd -f argo-ingress.yaml
# kubectl apply -n argocd -f argo-custom-image.yaml



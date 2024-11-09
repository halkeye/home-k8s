helm diff upgrade argo-cd . --allow-unreleased --namespace argocd --values values.yaml --values secrets://values-secrets.yaml

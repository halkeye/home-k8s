helm upgrade -i argo-cd . --namespace argocd --values values.yaml --values secrets://values-secrets.yaml

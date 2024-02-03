helm upgrade -i argo-cd . --namespace argocd --create-namespace --values values.yaml --values secrets://values-secrets.yaml

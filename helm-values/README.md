# Helm Values

Values file for `kube-prometheus-stack`.

## Install

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f helm-values/kube-prometheus-stack-values.yaml
```

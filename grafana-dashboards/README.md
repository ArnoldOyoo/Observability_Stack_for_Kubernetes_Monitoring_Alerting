# Grafana Dashboards

Custom dashboards (JSON) for the observability stack.

## Import manually

- `cluster-resources.json`
- `custom-app.json`

## Import via ConfigMaps

```bash
kubectl create configmap grafana-dashboard-cluster-resources \
  --from-file=grafana-dashboards/cluster-resources.json \
  -n monitoring \
  -o yaml --dry-run=client | kubectl label -f - grafana_dashboard=1 --overwrite | kubectl apply -f -

kubectl create configmap grafana-dashboard-custom-app \
  --from-file=grafana-dashboards/custom-app.json \
  -n monitoring \
  -o yaml --dry-run=client | kubectl label -f - grafana_dashboard=1 --overwrite | kubectl apply -f -
```

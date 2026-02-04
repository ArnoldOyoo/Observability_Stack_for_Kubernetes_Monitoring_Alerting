# Runbook

This runbook is a quick reference for verifying the observability stack and troubleshooting common issues.

## Post-deploy verification

1. Confirm monitoring namespace

```bash
kubectl get ns monitoring
```

2. Check Prometheus targets

```bash
kubectl -n monitoring port-forward svc/kube-prometheus-stack-prometheus 9090:9090
```

Open Prometheus, then verify targets are `UP` for:
- `kube-state-metrics`
- `node-exporter`
- `custom-metrics-app`

3. Check Grafana

```bash
kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80
```

Import dashboards if not already present and verify panels render.

4. Check Alertmanager

```bash
kubectl -n monitoring port-forward svc/kube-prometheus-stack-alertmanager 9093:9093
```

Open Alertmanager and verify the routes and receivers.

## Force a test alert

Create a temporary rule to validate notifications:

```yaml
- alert: TestAlert
  expr: vector(1)
  for: 1m
  labels:
    severity: info
  annotations:
    summary: "Test alert"
    description: "This is a synthetic test alert"
```

Apply the rule, wait for it to fire, then remove it.

## Common issues

- **No custom metrics**
  - Verify the custom app pods are running and listening on port 8000.
  - Check the `additionalScrapeConfigs` in `helm-values/kube-prometheus-stack-values.yaml`.

- **Dashboards empty**
  - Confirm Grafana datasource points to Prometheus.
  - Ensure dashboards were imported and have the correct UID.

- **Alerts not firing**
  - Confirm `PrometheusRule` exists in `monitoring` namespace.
  - Check Prometheus rule evaluation errors.

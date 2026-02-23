# Runbook

Operational checklist for deploying and validating the observability stack.

## 1. Preflight

```bash
make preflight
```

If this fails, install missing tools, set `APP_IMAGE`, and create `terraform-cluster/terraform.tfvars`.

## 2. Deploy

### Full deploy (provisions cluster + installs stack)

```bash
make deploy-stack APP_IMAGE="$APP_IMAGE"
```

### Existing EKS cluster

```bash
SKIP_TERRAFORM=true make deploy-stack APP_IMAGE="$APP_IMAGE"
```

## 3. Verify

```bash
make verify-stack
```

This checks:

- `monitoring` namespace exists
- custom app deployment rollout succeeded
- kube-prometheus-stack pods are present
- Prometheus has an `UP` target for `custom-metrics-app`

## 4. Access services locally

```bash
kubectl -n monitoring port-forward svc/kube-prometheus-stack-prometheus 9090:9090
kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80
kubectl -n monitoring port-forward svc/kube-prometheus-stack-alertmanager 9093:9093
```

## 5. Force a test alert

Apply a short-lived synthetic rule:

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

After the alert fires and notifications are confirmed, remove the rule.

## Troubleshooting

- No custom app target in Prometheus:
  - `kubectl -n monitoring get pods -l app=custom-metrics-app`
  - confirm app pods are `Running` and serving `:8000/metrics`
- Dashboards empty:
  - confirm Prometheus datasource in Grafana
  - confirm dashboard ConfigMaps labeled `grafana_dashboard=1`
- Alerts not firing:
  - `kubectl -n monitoring get prometheusrule observability-alerts`
  - check Prometheus rule status and expression errors

# Observability Stack for Kubernetes (Monitoring + Alerting)

![CI](https://github.com/your-org/observability-stack/actions/workflows/ci.yaml/badge.svg)
![Terraform](https://img.shields.io/badge/terraform-fmt-blue)

Kubernetes observability platform using Prometheus, Grafana, Alertmanager, node-exporter, kube-state-metrics, and a custom metrics app. Deployed via Helm into an AWS-hosted Kubernetes cluster created by Terraform.

## Repository layout

- `terraform-cluster/` - EKS cluster provisioning (VPC + EKS).
- `helm-values/` - Helm values for kube-prometheus-stack.
- `prometheus-config/` - Alert rules and Prometheus config snippets.
- `grafana-dashboards/` - Custom dashboards.
- `custom-metrics-app/` - App exposing metrics endpoint.
- `docs/` - Architecture, screenshots, and alert examples.

## Deploy flow

1. Provision the cluster using `terraform-cluster/`.
2. Install kube-prometheus-stack with values from `helm-values/`.
3. Apply alert rules from `prometheus-config/`.
4. Deploy `custom-metrics-app/` and verify metrics scrape.
5. Import dashboards from `grafana-dashboards/`.

## Custom dashboards built

- `grafana-dashboards/cluster-resources.json` tracks node CPU/memory and namespace usage.
- `grafana-dashboards/custom-app.json` tracks custom app request rate, errors, p95 latency, and inflight requests.

## Alert rules written

See `prometheus-config/alert-rules.yaml`:

- `CustomAppHighErrorRate`
- `CustomAppLatencyP95High`
- `NodeCPUUsageHigh`
- `NodeMemoryUsageHigh`
- `KubernetesPodCrashLooping`

## Example alerts firing

Example alert output lives in `docs/alerts-example.md`.

## Metrics endpoint code

The custom metrics app exposes `/metrics` and tracks:

- `custom_app_requests_total`
- `custom_app_request_errors_total`
- `custom_app_request_latency_seconds`
- `custom_app_inflight_requests`

See `custom-metrics-app/app.py`.

## Cluster resource monitoring

Dashboards and alerts use node-exporter, kube-state-metrics, and cAdvisor metrics to monitor CPU, memory, and pod stability.

## Architecture

Diagram in `docs/architecture.md`.

## Runbook

Troubleshooting and validation steps in `docs/runbook.md`.

## Notes

- Update the CI badge URL to match your GitHub org and repo.

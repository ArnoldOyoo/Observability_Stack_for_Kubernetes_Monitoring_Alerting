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

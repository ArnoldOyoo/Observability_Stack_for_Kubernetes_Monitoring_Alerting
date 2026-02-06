# Observability Stack for Kubernetes (Monitoring + Alerting)

Kubernetes observability platform using Prometheus, Grafana, Alertmanager, node-exporter, kube-state-metrics, and a custom metrics app. Deployed via Helm into an AWS-hosted Kubernetes cluster created by Terraform.

```mermaid
flowchart LR
  Users [icon: users, color: green]

Custom Metrics App [icon: bar-chart, label: "Custom Metrics App"]

Service [icon: server, label: "Service", color: yellow, colorMode: outline]

Prometheus [icon: prometheus, color: orange, colorMode: bold]

Alertmanager [icon: bell, label: "Alertmanager", color: blue]

Grafana [icon: grafana, color: red]

Node Exporter [icon: cpu, label: "node-exporter"]

Kube State Metrics [icon: kubernetes, label: "kube-state-metrics", color: blue]

Slack Email Pager [icon: mail, label: "Slack/Email/Pager", color: red]

Custom Dashboards [icon: layout, label: "Custom Dashboards", color: green]

Terraform [icon: terraform, color: purple]

Helm [icon: helm, color: blue, styleMode: watercolor, colorMode: outline]

// EKS group
EKS [icon: aws-eks] {
  Custom Metrics App
  Service
  Prometheus
  Alertmanager
  Grafana
  Node Exporter
  Kube State Metrics
}

// Connections
Users > Custom Metrics App
Custom Metrics App > Service
Service > Prometheus: /metrics
Prometheus > Alertmanager
Prometheus > Grafana
Prometheus > Node Exporter
Prometheus > Kube State Metrics
Alertmanager > Slack Email Pager
Grafana > Custom Dashboards

Terraform > EKS
Helm > Prometheus
Helm > Grafana
Helm > Alertmanager
```



## layout

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

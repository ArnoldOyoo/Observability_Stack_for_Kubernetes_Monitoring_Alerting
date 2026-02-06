# Observability Stack for Kubernetes (Monitoring + Alerting)

Kubernetes observability platform using Prometheus, Grafana, Alertmanager, node-exporter, kube-state-metrics, and a custom metrics app. Deployed via Helm into an AWS-hosted Kubernetes cluster created by Terraform.

```mermaid
flowchart LR
  users((Users)) --> app[Custom Metrics App]
  app --> svc[Service]
  svc -->|/metrics| prom[Prometheus]
  prom --> am[Alertmanager]
  prom --> graf[Grafana]
  prom --> ne[node-exporter]
  prom --> ksm[kube-state-metrics]
  am --> notify[Slack/Email/Pager]
  graf --> dashboards[Custom Dashboards]

  subgraph EKS
    app
    svc
    prom
    am
    graf
    ne
    ksm
  end

  terraform[Terraform] --> EKS
  helm[Helm] --> prom
  helm --> graf
  helm --> am
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

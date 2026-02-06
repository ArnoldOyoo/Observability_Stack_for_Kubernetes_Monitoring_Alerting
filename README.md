# Observability Stack for Kubernetes (Monitoring + Alerting)

Kubernetes observability platform using Prometheus, Grafana, Alertmanager, node-exporter, kube-state-metrics, and a custom metrics app. Deployed via Helm into an AWS-hosted Kubernetes cluster created by Terraform.

```mermaid
flowchart LR
  %% =====================
  %% External Actors
  %% =====================
  users((👤 Users)):::users --> app

  %% =====================
  %% Core App Flow
  %% =====================
  app[📊 Custom Metrics App]:::app --> svc
  svc[🔌 Service]:::svc -->| /metrics | prom

  %% =====================
  %% Observability Stack
  %% =====================
  prom[📈 Prometheus]:::prom --> am
  prom --> graf
  prom --> ne
  prom --> ksm

  am[🚨 Alertmanager]:::alert --> notify
  graf[📉 Grafana]:::graf --> dashboards

  notify[📬 Slack / Email / Pager]:::notify
  dashboards[🧩 Custom Dashboards]:::dash

  ne[🖥️ node-exporter]:::exporter
  ksm[☸️ kube-state-metrics]:::exporter

  %% =====================
  %% Infrastructure Layer
  %% =====================
  terraform[🏗️ Terraform]:::iac --> EKS
  helm[⛵ Helm]:::iac --> prom
  helm --> graf
  helm --> am

  %% =====================
  %% EKS Cluster
  %% =====================
  subgraph EKS["☸️ Amazon EKS Cluster"]
    direction LR
    app
    svc
    prom
    am
    graf
    ne
    ksm
  end

  %% =====================
  %% Styling
  %% =====================
  classDef users fill:#E3F2FD,stroke:#1E88E5,stroke-width:2px,color:#0D47A1
  classDef app fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px
  classDef svc fill:#F1F8E9,stroke:#7CB342
  classDef prom fill:#FFF3E0,stroke:#FB8C00,stroke-width:2px
  classDef alert fill:#FDECEA,stroke:#E53935,stroke-width:2px
  classDef graf fill:#E1F5FE,stroke:#039BE5,stroke-width:2px
  classDef exporter fill:#F3E5F5,stroke:#8E24AA
  classDef notify fill:#FFEBEE,stroke:#C62828
  classDef dash fill:#E0F2F1,stroke:#00897B
  classDef iac fill:#ECEFF1,stroke:#455A64,stroke-dasharray: 5 5

  style EKS fill:#FAFAFA,stroke:#90A4AE,stroke-width:2px

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

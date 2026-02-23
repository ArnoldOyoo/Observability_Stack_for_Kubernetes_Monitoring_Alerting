# Kubernetes Observability Stack

A practical observability project I built to monitor a Kubernetes app end-to-end.

It uses:
- Terraform (cluster infra)
- Helm + kube-prometheus-stack
- Prometheus + Grafana + Alert rules
- A small custom metrics app

## Architecture

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

  subgraph Kubernetes
    app
    svc
    prom
    am
    graf
    ne
    ksm
  end

  terraform[Terraform] --> Kubernetes
  helm[Helm] --> prom
  helm --> graf
  helm --> am
```

## What I actually validated

- custom app metrics are scraped by Prometheus (`custom-metrics-app` targets are `UP`)
- dashboards render live app metrics in Grafana
- automated verification script passes (`make verify-stack`)

## Proof

### Prometheus target health
![Prometheus target health](docs/screenshots/prometheus-target-health.png)

### Grafana custom metrics dashboard
![Grafana custom metrics dashboard](docs/screenshots/grafana-custom-metrics-dashboard.png)

### Verification run
![Verify stack success](docs/screenshots/verify-stack-success.png)

## How to run

```bash
make preflight
make deploy-stack APP_IMAGE="$APP_IMAGE"
make verify-stack
```

For local demo without AWS, I also ran this on a `kind` cluster.

## Notes

- evidence logs are in `docs/evidence/`
- dashboards are in `grafana-dashboards/`
- this repo includes fixes made during testing (dashboard import + verify script reliability)

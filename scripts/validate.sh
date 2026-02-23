#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "Running Terraform formatting check..."
terraform -chdir=terraform-cluster fmt -check -recursive

if [[ "${SKIP_TERRAFORM_VALIDATE:-false}" != "true" ]]; then
  echo "Running Terraform validate..."
  terraform -chdir=terraform-cluster init -backend=false -input=false >/tmp/terraform-init.log
  terraform -chdir=terraform-cluster validate
else
  echo "Skipping Terraform validate (SKIP_TERRAFORM_VALIDATE=true)."
fi

if [[ "${SKIP_KUBECTL_VALIDATE:-false}" != "true" ]]; then
  echo "Validating Kubernetes manifests with kubectl dry-run..."
  kubectl apply --dry-run=client -f custom-metrics-app/k8s.yaml >/dev/null
  kubectl apply --dry-run=client -f prometheus-config/prometheus-rules.yaml >/dev/null
else
  echo "Skipping kubectl dry-run validation (SKIP_KUBECTL_VALIDATE=true)."
fi

echo "Validating dashboard JSON..."
python3 -m json.tool grafana-dashboards/cluster-resources.json >/dev/null
python3 -m json.tool grafana-dashboards/custom-app.json >/dev/null

echo "Validating Python app syntax..."
python3 -m py_compile custom-metrics-app/app.py

echo "Validation completed."

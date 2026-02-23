#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

SKIP_TERRAFORM="${SKIP_TERRAFORM:-false}"
AWS_REGION="${AWS_REGION:-us-east-1}"
CLUSTER_NAME="${CLUSTER_NAME:-observability-eks}"

scripts/preflight.sh

if [[ "$SKIP_TERRAFORM" != "true" ]]; then
  make terraform-init
  make terraform-apply
fi

make kubeconfig AWS_REGION="$AWS_REGION" CLUSTER_NAME="$CLUSTER_NAME"
make helm-install
make rules-apply
make app-deploy APP_IMAGE="${APP_IMAGE}"
make dashboards-import

echo "Deployment completed. Run 'make verify-stack' next."

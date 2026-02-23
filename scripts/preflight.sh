#!/usr/bin/env bash
set -euo pipefail

required_commands=(terraform aws helm kubectl curl python3)
missing=()

for cmd in "${required_commands[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    missing+=("$cmd")
  fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "Missing required tools: ${missing[*]}"
  echo "Install required tools and rerun."
  exit 1
fi

if [[ ! -f terraform-cluster/terraform.tfvars ]]; then
  echo "Missing terraform variables file: terraform-cluster/terraform.tfvars"
  echo "Copy terraform-cluster/terraform.tfvars.example and update values."
  exit 1
fi

if [[ "${APP_IMAGE:-}" == "" ]]; then
  echo "APP_IMAGE is not set."
  echo "Example: export APP_IMAGE=123456789012.dkr.ecr.us-east-1.amazonaws.com/custom-metrics-app:$(date +%Y%m%d-%H%M%S)"
  exit 1
fi

echo "Preflight checks passed."

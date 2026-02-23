#!/usr/bin/env bash
set -euo pipefail

echo "Checking namespace and pods..."
kubectl get ns monitoring >/dev/null
kubectl -n monitoring get pods

echo "Checking custom app rollout..."
kubectl -n monitoring rollout status deployment/custom-metrics-app --timeout=180s

echo "Checking Prometheus, Grafana, Alertmanager pods..."
kubectl -n monitoring get pods -l app.kubernetes.io/instance=kube-prometheus-stack

echo "Waiting for Prometheus and Grafana pods to become Ready..."
kubectl -n monitoring rollout status statefulset/prometheus-kube-prometheus-stack-prometheus --timeout=600s
kubectl -n monitoring rollout status deployment/kube-prometheus-stack-grafana --timeout=600s

echo "Verifying custom scrape target from Prometheus API..."
kubectl -n monitoring port-forward svc/kube-prometheus-stack-prometheus 9090:9090 >/tmp/prom-port-forward.log 2>&1 &
PF_PID=$!
cleanup() {
  kill "$PF_PID" >/dev/null 2>&1 || true
}
trap cleanup EXIT

for _ in {1..30}; do
  if curl -fsS http://127.0.0.1:9090/-/ready >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

curl -fsS http://127.0.0.1:9090/-/ready >/dev/null
TARGETS_JSON="$(curl -sS http://127.0.0.1:9090/api/v1/targets)"
TARGETS_FILE="$(mktemp)"
printf '%s' "$TARGETS_JSON" >"$TARGETS_FILE"

python3 - "$TARGETS_FILE" <<'PY'
import json
import sys

with open(sys.argv[1], "r", encoding="utf-8") as f:
    raw = f.read()
payload = json.loads(raw)
active = payload.get("data", {}).get("activeTargets", [])
custom = [t for t in active if t.get("labels", {}).get("job") == "custom-metrics-app"]
up = [t for t in custom if t.get("health") == "up"]

if not custom:
    print("No custom-metrics-app targets found in Prometheus.")
    sys.exit(1)

if not up:
    print("custom-metrics-app target exists but is not UP.")
    sys.exit(1)

print(f"Prometheus target check passed: {len(up)}/{len(custom)} custom-metrics-app target(s) are UP.")
PY

rm -f "$TARGETS_FILE"

echo "Verification completed."

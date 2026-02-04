# Custom Metrics App

Simple Flask app exposing Prometheus metrics at `/metrics`.

## Metrics

- `custom_app_requests_total`
- `custom_app_request_errors_total`
- `custom_app_request_latency_seconds`
- `custom_app_inflight_requests`

## Run locally

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python app.py
```

import random
import time
from flask import Flask, Response
from prometheus_client import Counter, Gauge, Histogram, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

REQUESTS_TOTAL = Counter(
    "custom_app_requests_total",
    "Total HTTP requests",
    ["endpoint", "method"],
)
REQUEST_ERRORS_TOTAL = Counter(
    "custom_app_request_errors_total",
    "Total error responses",
    ["endpoint", "method"],
)
REQUEST_LATENCY = Histogram(
    "custom_app_request_latency_seconds",
    "Request latency in seconds",
    ["endpoint", "method"],
    buckets=(0.01, 0.05, 0.1, 0.2, 0.5, 1, 2, 5),
)
INFLIGHT_REQUESTS = Gauge(
    "custom_app_inflight_requests",
    "Number of inflight requests",
)


def simulate_work():
    latency = random.uniform(0.02, 0.6)
    time.sleep(latency)
    return latency


@app.route("/")
def index():
    INFLIGHT_REQUESTS.inc()
    try:
        latency = simulate_work()
        REQUESTS_TOTAL.labels(endpoint="/", method="GET").inc()
        REQUEST_LATENCY.labels(endpoint="/", method="GET").observe(latency)
        if random.random() < 0.04:
            REQUEST_ERRORS_TOTAL.labels(endpoint="/", method="GET").inc()
            return "error", 500
        return "ok", 200
    finally:
        INFLIGHT_REQUESTS.dec()


@app.route("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)

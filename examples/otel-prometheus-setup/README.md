# Using OpenTelemetry and Prometheus with PeerDB

This example demonstrates how to use OpenTelemetry and Prometheus with PeerDB.

## Assumptions

OpenTelemetry and Prometheus are being installed in the `telemetry` namespace, the example can be modified to use a different namespace.

Install it by running:
```shell
helm install --debug peerdb-telemetry peerdb-telemetry --namespace telemetry --create-namespace
```

## OpenTelemetry and Prometheus setup

This example includes a helm chart with OpenTelemetry Collector and Prometheus with sane defaults (check the `values.yaml` file for more details):
1. OpenTelemetry is
   1. enabling a prometheus-compatible endpoint at port `9090`
   2. enabling the `prometheus` exporter
   3. exposing the port `9090` which was just enabled so that Prometheus can scrape the metrics
   
   Other configuration like the `otlp-http` endpoint, healthcheck etc. is enabled by default in the chart
2. Prometheus is
   1. scraping the OpenTelemetry Collector at `http://peerdb-telemetry-collector.telemetry:9090/metrics`
   2. has a load balancer service to expose the Prometheus UI


## PeerDB setup

PeerDB needs to be configured to send metrics to the OpenTelemetry Collector. This can be done by configuring the `values.customer.yaml`
in the PeerDB helm chart:

```yaml
flowWorker:
  extraEnv:
   - name: ENABLE_OTEL_METRICS
     value: "true"
   - name: OTEL_EXPORTER_OTLP_METRICS_ENDPOINT
     value: http://peerdb-telemetry-collector.telemetry:4318/v1/metrics
```

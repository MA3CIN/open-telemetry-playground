# open-telemetry-playground
Automatic instrumentation of Golang applications using Open Telemetry.

K8s-open-telemetry contains all yaml files to setup the collector.

# Prerequisites:
    Kubernetes 1.24+ is required for OpenTelemetry Operator installation
    Helm 3.9+


go-server contains a go application with an HTTP server.

probe-example is an experiment conducted with kubeshark, to see from where the probes originate
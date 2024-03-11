helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm install my-opentelemetry-collector open-telemetry/opentelemetry-collector \
-f config-daemonset.yaml
# --dry-run
# --set mode=daemonset
#! /bin/bash

repo_url=https://open-telemetry.github.io/opentelemetry-helm-charts

set -e

echo '+ Installing otel-demo'

echo "+ kubeconfig: $KUBECONFIG"

echo '+ Adding otel helm repo'
helm repo add open-telemetry $repo_url

if helm status -n otel-demo otel-demo >/dev/null 2>/dev/null; then
  echo '+ Otel-demo already installed and does not support upgrading. Explicitly do'
  echo '+ KUBECONFIG=$KUBECONFIG helm uninstall -n otel-demo otel-demo'
  echo '+ to remove it if you want to reinstall'
else
  echo '+ Installing helm chart'
  helm install otel-demo open-telemetry/opentelemetry-demo --namespace otel-demo --create-namespace -f ../common/helm/otel-demo-values.yaml
fi

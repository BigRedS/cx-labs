#! /bin/bash

# Installs the Coralogix helm chart. Pass the path to a file to use that as the values file
# else defaults to ./helm/coralogix-otel-values.yaml

repo_url=https://cgx.jfrog.io/artifactory/coralogix-charts-virtual

set -e

echo '+ installing Coralogix OTel chart'

echo "+ kubeconfig: $KUBECONFIG"

echo '+ Adding CX helm repo'
helm repo add coralogix $repo_url
helm repo update

if kubectl get secret coralogix-keys 2>/dev/null >/dev/null ; then
  echo '+ Secret already exists, preserving it'
else
  if [ -z $CX_DATA_KEY ]; then
    echo "ERROR: Env var CX_DATA_KEY must be set with a send-your-data key for the receiving environment"
    echo "(also check your helm/values.yaml has the right endpoint while you're here!)"
  else
    echo '+ Creating secret'
    kubectl create secret generic coralogix-keys --from-literal=PRIVATE_KEY=$CX_DATA_KEY
  fi
fi

echo '+ Installing helm chart'

if [[ -n "$CX_DOMAIN" ]]; then
  echo "+ setting global.domain to '$CX_DOMAIN'"
  HELM_SET="--set global.domain=$CX_DOMAIN"
fi

if [[ ! -z "$1" && -f "$1" ]]; then
  echo "Using values file at $1"
  helm upgrade --install otel-coralogix-integration coralogix/otel-integration $HELM_SET -f $1 --render-subchart-notes
else
  helm upgrade --install otel-coralogix-integration coralogix/otel-integration $HELM_SET -f ../common/helm/coralogix-otel-values.yaml --render-subchart-notes
fi

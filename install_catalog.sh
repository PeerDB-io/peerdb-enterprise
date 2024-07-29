#!/bin/bash
set -Eeuo pipefail

# Source .env file
set -a
source .env
set +a

function echo_err() {
    echo "$@" >&2
}

CHART_MODE=${1:-install}

if [[ "$CHART_MODE" == "install" ]]; then
  echo "Will install the chart..."
  HELM_ARGS=("upgrade" "--install")
elif [[ "$CHART_MODE" == "template" ]]; then
  echo_err "Will template the chart..."
  HELM_ARGS=("template")
else
  echo_err 'USAGE: ./install_catalog.sh install|template'
  exit 1
fi


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PEERDB_CATALOG_DIR="${SCRIPT_DIR}/peerdb-catalog"

"${SCRIPT_DIR}/values_catalog.sh"


pushd "${PEERDB_CATALOG_DIR}" >&2


export PEERDB_CATALOG_RELEASE_NAME="${PEERDB_RELEASE_NAME}-catalog"

helm dependencies update >&2


if [[ "$CHART_MODE" == "install" ]]; then
  # Workaround till https://github.com/helm/helm/pull/12362 gets merged
  if [[ "$CATALOG_DEPLOY_ENABLED" == "true" ]] && crds_manifests="$(helm template . \
    --values ../peerdb-catalog.values.secret.yaml \
    --values values.customer.yaml \
    --include-crds \
    --namespace "${PEERDB_K8S_NAMESPACE}" | yq -e '. | select (.kind == "CustomResourceDefinition")')" ; then
    echo 'Found CRDS, applying...'
    echo "${crds_manifests}" | kubectl apply --server-side -f -
  else
    echo 'No CRDS found'
  fi
fi

helm "${HELM_ARGS[@]}" "${PEERDB_CATALOG_RELEASE_NAME}" . \
  --debug \
  --values values.customer.yaml \
  --values ../peerdb-catalog.values.secret.yaml \
  --namespace "${PEERDB_K8S_NAMESPACE}"\
  --create-namespace \
  --wait \
  --timeout=15m

popd >&2

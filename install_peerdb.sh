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
  echo_err 'USAGE: ./install_peerdb.sh install|template'
  exit 1
fi


# Now we are using the same helm chart
export TEMPORAL_RELEASE_NAME="${PEERDB_RELEASE_NAME}-temporal-deploy"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PEERDB_DIR="${SCRIPT_DIR}/peerdb"

"${SCRIPT_DIR}/values_peerdb.sh"


pushd "${PEERDB_DIR}" >&2


helm dependencies update >&2

helm "${HELM_ARGS[@]}" "${PEERDB_RELEASE_NAME}" . \
  --debug \
  --values ../peerdb.values.secret.yaml \
  --values values.customer.yaml \
  --namespace "${PEERDB_K8S_NAMESPACE}"\
  --create-namespace \
  --wait \
  --timeout=15m

popd >&2

if [[ "$CHART_MODE" == "install" ]]; then
  if [[ "$AUTHENTICATION_ENABLED" == "true" ]]; then
    auth_ip=$(kubectl -n "${PEERDB_K8S_NAMESPACE}" get svc authentication-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    if [[ -n "${TEMPORAL_CLOUD_HOST:-}" ]]; then
      echo "Authenticated UI IP is $auth_ip. Please set/update DNS entries starting with \`peerdb.\`, \`peerdb-ui.\` to point to $auth_ip "
    else
      echo "Authenticated UI IP is $auth_ip. Please set/update DNS entries starting with \`temporal.\`, \`peerdb.\` and \`peerdb-ui.\` to point to $auth_ip "
    fi
  fi
fi
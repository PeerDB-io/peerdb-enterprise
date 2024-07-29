#!/bin/bash
set -Eeuo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source .env file in parent directory
set -a
source "${SCRIPT_DIR}/../.env"
set +a

kubectl -n ${TEMPORAL_K8S_NAMESPACE} exec -it services/${TEMPORAL_RELEASE_NAME}-admintools -- /bin/bash

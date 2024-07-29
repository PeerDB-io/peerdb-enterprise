#!/bin/bash
set -Eeuo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source .env file in parent directory
set -a
source "${SCRIPT_DIR}/../.env"
set +a

kubectl port-forward -n ${TEMPORAL_K8S_NAMESPACE} services/${TEMPORAL_RELEASE_NAME}-web 8080:8080

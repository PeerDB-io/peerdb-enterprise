#!/bin/bash
set -Eeuo pipefail

# Source .env file
set -a
source .env
set +a

helm test -n "$PEERDB_K8S_NAMESPACE" "$PEERDB_RELEASE_NAME"-catalog --logs --timeout 30s
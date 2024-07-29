#!/bin/bash
set -Eeuo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source .env file in parent directory
set -a
source "${SCRIPT_DIR}/../.env"
set +a


source "$SCRIPT_DIR/../port_forward_catalog.sh" && check_catalog_deploy

psql "host=${PG_HOST} port=${PG_PORT} user=${PG_USER} password=${PG_PASSWORD} dbname=${PEERDB_CATALOG_DATABASE}"

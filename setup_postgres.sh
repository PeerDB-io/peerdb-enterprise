#!/bin/bash
set -Eeuo pipefail


# Source .env file
set -a; source .env; set +a



SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PG_SETUP_DIR="${SCRIPT_DIR}/peerdb-catalog/pgSetup"

source "$SCRIPT_DIR/port_forward_catalog.sh" && check_catalog_deploy


pushd $PG_SETUP_DIR

make
./peerdb-pg-setup

popd

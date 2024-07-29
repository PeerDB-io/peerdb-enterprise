#!/bin/bash
set -Eeuo pipefail

# source .env file
set -a
source .env
set +a


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TEMPORAL_SETUP_DIR="${SCRIPT_DIR}/temporal"


source "$SCRIPT_DIR/port_forward_catalog.sh" && check_catalog_deploy

export SQL_PLUGIN=postgres12
export SQL_HOST=$PG_HOST
export SQL_PORT=$PG_PORT
export SQL_USER=$TEMPORAL_USER
export SQL_TLS=$TEMPORAL_SSL_MODE

if [ -n "${TEMPORAL_SSL_CA_CERT_PATH:-}" ]; then
    export SQL_TLS_CA_FILE=$TEMPORAL_SSL_CA_CERT_PATH
fi

export SQL_PASSWORD=$TEMPORAL_PASSWORD

pushd $TEMPORAL_SETUP_DIR

make temporal-sql-tool

echo "Setting up Temporal schema for Postgres - $SQL_HOST:$SQL_PORT - $TEMPORAL_DB"
# ./temporal-sql-tool --database temporal create-database
SQL_DATABASE=${TEMPORAL_DB} ./temporal-sql-tool --db $TEMPORAL_DB setup-schema -v 0.0
SQL_DATABASE=${TEMPORAL_DB} ./temporal-sql-tool --db $TEMPORAL_DB update -schema-dir schema/postgresql/v12/temporal/versioned

echo "Setting up Temporal visibility schema for Postgres - $SQL_HOST:$SQL_PORT - $TEMPORAL_VISIBILITY_DB"
# ./temporal-sql-tool --database temporal_visibility create-database
SQL_DATABASE=${TEMPORAL_VISIBILITY_DB} ./temporal-sql-tool --db $TEMPORAL_VISIBILITY_DB setup-schema -v 0.0
SQL_DATABASE=${TEMPORAL_VISIBILITY_DB} ./temporal-sql-tool --db $TEMPORAL_VISIBILITY_DB update -schema-dir schema/postgresql/v12/visibility/versioned

popd

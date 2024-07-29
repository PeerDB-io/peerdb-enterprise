#!/usr/bin/env bash


#TEMPORAL_HOST="${TEMPORAL_RELEASE_NAME}-frontend.${TEMPORAL_K8S_NAMESPACE}.svc.cluster.local"

if [[ "$CATALOG_DEPLOY_ENABLED" == "true" ]]; then
  PG_HOST="${CATALOG_DEPLOY_CLUSTER_NAME}-primary.${PEERDB_K8S_NAMESPACE}.svc.cluster.local"
  TEMPORAL_DEFAULT_USER_PASSWORD_EXISTING_SECRET="${CATALOG_DEPLOY_CLUSTER_NAME}-pguser-${TEMPORAL_USER}"
  TEMPORAL_VISIBILITY_USER_PASSWORD_EXISTING_SECRET="${CATALOG_DEPLOY_CLUSTER_NAME}-pguser-${TEMPORAL_USER}"
fi


if [[ -n "${TEMPORAL_CLOUD_HOST:-}" ]]; then
  TEMPORAL_DEPLOY_ENABLED=false
else
  TEMPORAL_DEPLOY_ENABLED=true
fi


if [[ "$PG_RDS_SSL_ENABLED" == "true" ]]; then
  TEMPORAL_SSL_MODE=true
  TEMPORAL_SSL_TYPE=RDS
fi


cat << EOF > 'peerdb-catalog.values.secret.yaml'

credentials:
  default:
    user: "${TEMPORAL_USER}"
    password: "${TEMPORAL_PASSWORD}"
    database: "${TEMPORAL_DB}"
    existingSecret: "${TEMPORAL_DEFAULT_USER_PASSWORD_EXISTING_SECRET}"

  visibility:
    user: "${TEMPORAL_USER}"
    password: "${TEMPORAL_PASSWORD}"
    database: "${TEMPORAL_VISIBILITY_DB}"
    existingSecret: "${TEMPORAL_VISIBILITY_USER_PASSWORD_EXISTING_SECRET}"

  admin:
    user: "${PG_USER}"
    password: "${PG_PASSWORD}"
    database: "${PG_DATABASE}"

  catalog:
    database: "${PEERDB_CATALOG_DATABASE}"
  pgHost: "${PG_HOST}"
  pgPort: "${PG_PORT}"
  secretName: "${PEERDB_CATALOG_CREDS_SECRET_NAME}"
  ssl:
    enabled: ${TEMPORAL_SSL_MODE}
    type: "${TEMPORAL_SSL_TYPE:-}"
    path: _TEMPORAL_SSL_CA_CERT_PATH_

deploy:
  enabled: ${CATALOG_DEPLOY_ENABLED}
  clusterName: "${CATALOG_DEPLOY_CLUSTER_NAME}"


temporal:
  deploy:
    enabled: ${TEMPORAL_DEPLOY_ENABLED}
  tls:
    enabled: ${TEMPORAL_SSL_MODE}

global:
  peerdb:
    enterprise:
      saveCustomerValuesAsSecret: ${SAVE_VALUES_AS_SECRET}

EOF

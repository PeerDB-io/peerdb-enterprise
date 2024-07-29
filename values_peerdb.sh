#!/usr/bin/env bash


TEMPORAL_HOST="${TEMPORAL_RELEASE_NAME}-frontend.${PEERDB_K8S_NAMESPACE}.svc.cluster.local"

if [[ "$CATALOG_DEPLOY_ENABLED" == "true" ]]; then
  PG_HOST="${CATALOG_DEPLOY_CLUSTER_NAME}-primary.${PEERDB_K8S_NAMESPACE}.svc.cluster.local"
  TEMPORAL_DEFAULT_USER_PASSWORD_EXISTING_SECRET="${CATALOG_DEPLOY_CLUSTER_NAME}-pguser-${TEMPORAL_USER}"
  TEMPORAL_VISIBILITY_USER_PASSWORD_EXISTING_SECRET="${CATALOG_DEPLOY_CLUSTER_NAME}-pguser-${TEMPORAL_USER}"
fi


if [[ -n "${TEMPORAL_CLOUD_HOST:-}" ]]; then
  TEMPORAL_HOST="${TEMPORAL_CLOUD_HOST}"
  TEMPORAL_DEPLOY_ENABLED=false
else
  TEMPORAL_HOST="${TEMPORAL_RELEASE_NAME}-frontend.${PEERDB_K8S_NAMESPACE}.svc.cluster.local"
  TEMPORAL_DEPLOY_ENABLED=true
fi


# Temporal UI will be proxied through the authentication proxy if authentication is enabled
if [[ "$AUTHENTICATION_ENABLED" == "true" ]]; then
  TEMPORAL_UI_SERVICE_TYPE="ClusterIP"
else
  TEMPORAL_UI_SERVICE_TYPE="LoadBalancer"
fi

cat << EOF > peerdb.values.secret.yaml
catalog:
  pgHost: "${PG_HOST}"
  pgPort: "${PG_PORT}"
  pgUser: "${PG_USER}"
  pgPassword: "${PG_PASSWORD}"
  pgDatabase: "${PEERDB_CATALOG_DATABASE}"
  pgAdminDatabase: "${PG_DATABASE}"
  deploy:
    enabled: ${CATALOG_DEPLOY_ENABLED}
    clusterName: "${CATALOG_DEPLOY_CLUSTER_NAME}"
  credentialsSecretName: "${PEERDB_CATALOG_CREDS_SECRET_NAME}"

temporal:
  namespace: "${PEERDB_TEMPORAL_NAMESPACE}"
  releaseName: "${TEMPORAL_RELEASE_NAME}"
  host: "${TEMPORAL_HOST}"
  clientCert: "${TEMPORAL_CLOUD_CLIENT_CERT}"
  clientKey: "${TEMPORAL_CLOUD_CLIENT_KEY}"
  taskQueueId: "${PEERDB_DEPLOYMENT_UID}"
  deploy:
    enabled: ${TEMPORAL_DEPLOY_ENABLED}

peerdb:
  credentials:
    password: "${PEERDB_PASSWORD}"
  version: "${PEERDB_VERSION}"

peerdbUI:
  credentials:
    password: "${PEERDB_UI_PASSWORD}"
    nexauth_secret: "${PEERDB_UI_NEXTAUTH_SECRET}"
  service:
    url: "${PEERDB_UI_SERVICE_URL}"
aws:
  region: "${AWS_REGION}"
  roleArn: "${AWS_ROLE_ARN}"
  accessKeyId: "${AWS_ACCESS_KEY_ID}"
  secretAccessKey: "${AWS_SECRET_ACCESS_KEY}"

serviceAccount:
  name: "${SERVICE_ACCOUNT_NAME}"

authentication:
  enabled: ${AUTHENTICATION_ENABLED}
  credentials:
    username: "${AUTHENTICATION_CREDENTIALS_USERNAME}"
    password: "${AUTHENTICATION_CREDENTIALS_PASSWORD}"
temporal-deploy:
  server:
    config:
      persistence:
        default:
          sql:
            user: "${TEMPORAL_USER}"
            password: "${TEMPORAL_PASSWORD}"
            existingSecret: "${TEMPORAL_DEFAULT_USER_PASSWORD_EXISTING_SECRET}"
            database: "${TEMPORAL_DB}"
            tls:
              enabled: ${TEMPORAL_SSL_MODE}
            host: "${PG_HOST}"
            port: "${PG_PORT}"
        visibility:
          sql:
            user: "${TEMPORAL_USER}"
            password: "${TEMPORAL_PASSWORD}"
            existingSecret: "${TEMPORAL_VISIBILITY_USER_PASSWORD_EXISTING_SECRET}"
            database: "${TEMPORAL_VISIBILITY_DB}"
            tls:
              enabled: ${TEMPORAL_SSL_MODE}
            host: "${PG_HOST}"
            port: "${PG_PORT}"
  web:
    service:
      type: "${TEMPORAL_UI_SERVICE_TYPE}"
datadog:
  enabled: $DATADOG_ENABLED
  datadog:
    site: $DATADOG_SITE
    apiKey: $DATADOG_API_KEY
    clusterName: $DATADOG_CLUSTER_NAME
    containerInclude: "kube_namespace:${PEERDB_K8S_NAMESPACE}"

global:
  peerdb:
    enterprise:
      saveCustomerValuesAsSecret: ${SAVE_VALUES_AS_SECRET}

EOF

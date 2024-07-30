
<div align="center">

<img src="images/banner.jpg" alt="PeerDB Banner" width="512" />

#### Frustratingly simple ETL for Postgres

[![ElV2 License](https://badgen.net/badge/License/Elv2/green?icon=github)](https://github.com/PeerDB-io/peerdb-enterprise/blob/main/LICENSE.md)
[![Slack Community](https://img.shields.io/badge/slack-peerdb-brightgreen.svg?logo=slack)](https://join.slack.com/t/peerdb-public/shared_invite/zt-1wo9jydev-EXInbMtCtpAKFFWdi7QvLQ)

</div>

## PeerDB

At PeerDB, we are building a fast, simple and the most cost effective way to stream data from Postgres to a host of Data Warehouses, Queues and Storage Engines. If you are running Postgres at the heart of your data-stack and move data at scale from Postgres to any of the above targets, PeerDB can provide value.

[PeerDB was acquired by ClickHouse](https://blog.peerdb.io/clickhouse-acquires-peerdb-for-native-postgres-cdc-integration) in July 2024. As part of this acquisition, we're making public the repository that contains the Helm charts used for deploying our Enterprise offering. This will enable people to self-host PeerDB in a more reliable and scaleable manner.

## Overview

PeerDB itself has 5 main services:

1. `flow-worker`: The service that actually runs mirrors and does all the data movement. Written in Golang, source code [here](https://github.com/PeerDB-io/peerdb/tree/main/flow).
2. `flow-snapshot-worker`: Helps `flow-worker` perform initial snapshot of mirrors. Needs to be available at all times during this phase of a mirror. Shares source code with `flow-worker`.
3. `flow-api`: Hosts the gRPC API that actually creates and manages mirrors. `peerdb-ui` and `peerdb-server` depend on this. Shares source code with `flow-worker` and `flow-snapshot-worker`.
4. `peerdb-ui`: Intuitive web UI for interacting with peers and mirrors. Written in Next.js, source code [here](https://github.com/PeerDB-io/peerdb/tree/main/ui).
5. `peerdb-server`: Postgres wire protocol compatible SQL query layer, allows creating peers and mirrors via `psql` and other Postgres tooling. Written in Rust, source code [here](https://github.com/PeerDB-io/peerdb/tree/main/nexus).

For a more detailed overview of PeerDB's architecture, you can look [here](https://docs.peerdb.io/architecture). Aside from this, PeerDB needs a Postgres database to use as a "catalog" to store configuration, and [Temporal](https://temporal.io) for workflow orchestration. Both can either be cloud-based or self-hosted (self-hosted Temporal in turn needs Postgres too), and the charts can be configured according to your needs.

The sections below provide a quick way to get started with using the charts (like a POC). You can jump to the [Production Guide](#production-usage-post-poc) post POC (or if you are comfortable enough).

## Install Dependencies

### Needed
1. helm
2. kubectl
3. [yq](https://github.com/mikefarah/yq)

### Optional
1. Golang (if you need to setup catalog manually)
2. [k9s](https://github.com/derailed/k9s) for debugging
3. `psql` if you need to interface with `peerdb-server`

## Setup Kubernetes Cluster

1. Create a Kubernetes cluster on your favorite cloud provider
2. A sample node-pool/node-group for following the quickstart guide can look like:
   - Number of nodes: 3 (autoscaling recommended)
   - vCores: 8
   - Memory: 32GB
   - Disk: 300GB
   - Architecture: x64/ARM64
3. Setup your kubectl to point to the cluster

## QuickStart - Setting up PeerDB Enterprise
1. [Make sure all local dependencies are installed](#install-dependencies)
2. [Make sure Cluster is setup and kubectl is pointing to the cluster](#setup-kubernetes-cluster)
3. Clone this repo and create an `.env` file from `.env.template`.
4. [Setup In-Cluster Catalog Postgres](#option-b-in-cluster-with-helm-chart)
   1. Run `./install_catalog.sh`
   2. Run `./test_catalog.sh`
5. [Install PeerDB](#install-peerdb)
   1. [Update `.env` with `PEERDB_PASSWORD` and `PEERDB_UI_PASSWORD`](#setting-up-credentials-to-access-peerdb)
      1. Also generate a **new random string** for `PEERDB_UI_NEXTAUTH_SECRET` and set it in `.env`
   2. Run `./install_peerdb.sh` for the first time
   3. Set `PEERDB_UI_SERVICE_URL` in `.env` to the DNS/CNAME/IP of the LoadBalancer created and re-run `./install_peerdb.sh`
      1. `kubectl get service peerdb-ui -n peerdb-ns` to get the external IP of the peerdb server, to get the `external_ip` of the PeerDB UI server. (Change the namespace here if you have set a different namespace)
      2. Set the value to `PEERDB_UI_SERVICE_URL` in `.env` as `http://<external_ip>:3000`
   4. Re-run `./install_peerdb.sh` to update the service with the new DNS/CNAME/IP

## (Optional) Saving `values.customer.yaml` in the cluster as a secret for backup

Specific changes can be made to `values.customer.yaml` for both the `peerdb` and the `peerdb-catalog` helm charts.

`values.customer.yaml` can be backed up as kubernetes secrets. To enable this, set `SAVE_VALUES_AS_SECRET=true` in the `.env`


## Setup Catalog Postgres

### Option A. Self-Hosted/CloudNative

1. Deploy postgres as needed.
2. Update `.env` appropriately with the credentials
3. Set `CATALOG_DEPLOY_ENABLED=false` in `.env`
4. 1. If using RDS, enable SSL by setting `PG_RDS_SSL_ENABLED=true` in `.env`.
   2. If using SSL with another provider, set `TEMPORAL_SSL_MODE=true` in `.env`.
5. Run `./install_catalog.sh`, this will setup the schema.
6. Run `./test_catalog.sh` to verify schema version and permissions are in order


### Option B. In-Cluster with Helm Chart

1. Set `CATALOG_DEPLOY_ENABLED=true` in `.env`
2. Run `./install_catalog.sh`
3. Run `./test_catalog.sh` to verify schema version and permissions are in order once the postgres pods are up

#### NOTE: `PG_PASSWORD` will NOT be used from `.env` and will be auto-generated and can be obtained from the secret `"${CATALOG_DEPLOY_CLUSTER_NAME}-pguser-${PG_USER}"`

## [Optional] Enabling Datadog logs/metrics
1. Set `DATADOG_ENABLED=true`
2. Set the following parameters:
   ```
   DATADOG_SITE=<Datadog collection site, e.g. us5.datadoghq.com>
   DATADOG_API_KEY=<Datadog API Key>
   DATADOG_CLUSTER_NAME=<Datadog Cluster Name, something like customer-name-enterprise >
   ```

## Setting up credentials to access PeerDB

The following can be set in the `.env` to set up credentials to access PeerDB 
```
PEERDB_PASSWORD=peerdb
PEERDB_UI_PASSWORD=peerdb
```

Also set `PEERDB_UI_NEXTAUTH_SECRET` to a random static string
```
PEERDB_UI_NEXTAUTH_SECRET=<Randomly-Generated-Secret-String>
```


## [Optional] Enabling Authentication Proxy

1. Authentication for PeerDB UI and Temporal WebUI can be enabled by setting the following in `.env`:
    ```shell
    AUTHENTICATION_ENABLED=true
    AUTHENTICATION_CREDENTIALS_USERNAME=<username>
    AUTHENTICATION_CREDENTIALS_PASSWORD=<password>
    ```
    This will disable `LoadBalancer` for both the services and instead create a LoadBalancer for the Authentication Proxy.
2. Once Temporal and PeerDB are installed in the cluster, set/update DNS entries starting with `temporal.`, `peerdb.` and `peerdb-ui.` to point to the `LoadBalancer` IP of `authentication-proxy` service.
3. Temporal and PeerDB UI can be accessed through the DNS names set in previous step.

## Setup Catalog (Not required for in-cluster catalog)

### For Self-Hosted Temporal:

Catalog will automatically be setup (with schema update/migration) using k8s jobs via the helm chart. The jobs might go into a few retries before everything reconciles.

NOTE: Catalog can still be setup/upgraded via `./setup_postgres.sh` and `./setup_temporal_schema.sh` in case there is an issue.


### For Temporal Cloud:
1. Fill in the `TEMPORAL_CLOUD_HOST`, `TEMPORAL_CLOUD_CERT` and `TEMPORAL_CLOUD_KEY` environment variables in .env.
2. Fill in `PEERDB_DEPLOYMENT_UID` with an appropriate string to uniquely identify the current deployment.

## Install PeerDB

1. Run `./install_peerdb.sh` to install/upgrade peerdb on the kubernetes cluster.
2. Run `kubectl get service peerdb-server -n ${PEERDB_K8S_NAMESPACE}` to get the external IP of the peerdb server.
3. Validate that you are able to access temporal-web by:
   `kubectl port-forward -n ${TEMPORAL_K8S_NAMESPACE} services/${TEMPORAL_RELEASE_NAME}-web 8080:8080`

### Important Additional Steps
- If enabling service of type LoadBalancer, set `PEERDB_UI_SERVICE_URL` in `.env` to the DNS/CNAME/IP of the LoadBalancer for `peerdb-ui` service created and re-run `./install_peerdb.sh`. For example:
   ```
   PEERDB_UI_SERVICE_URL=http://aac397508d3594a4494dc9350812c40d-509756028.us-east-1.elb.amazonaws.com:3000
   ```

## Setting up Resources for PeerDB and In-Cluster Catalog
Setting up resources for PeerDB and In-Cluster Catalog is as simple as updating the `values.customer.yaml` file in the respective charts (`peerdb` and `peerdb-catalog`).

- `peerdb/values.customer.yaml`:
   ```yaml
   flowWorker:
      resources:
         requests:
            cpu: 12
            memory: 48Gi
            ephemeral-storage: 384Gi
         limits:
            cpu: 16
            memory: 64Gi
            ephemeral-storage: 512Gi
      replicaCount: 2
   ```
 - and `peerdb-catalog/values.customer.yaml`:
   ```yaml
   deploy:
      resources:
         requests:
            cpu: 2
            memory: 8Gi
         limits:
            cpu: 2
            memory: 8Gi
   ```

## Production usage post POC

A production guide setup with examples is available in [`PRODUCTION.md`](PRODUCTION.md).

## Issues and Fixes

### Accessing Temporal UI over non-HTTPS

Insecure cookie needs to be enabled to send commands/signals via the Temporal UI over plain HTTP and can be added to `peerdb/values.customer.yaml`:
```yaml
temporal-deploy:
  web:
    additionalEnv:
      - name: TEMPORAL_CSRF_COOKIE_INSECURE
        value: 'true'

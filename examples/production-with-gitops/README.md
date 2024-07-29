# Production setup with GitOps

This example shows usage of the Helm Charts while covering the following scenarios:
- Using a self-hosted/cloud Postgres for the catalog
  - Using a custom SSL certificate for the catalog
- Using secrets via kubernetes secrets
  - Leveraging [`ExternalSecrets`](https://external-secrets.io/) for syncing secrets from a secret manager
- Extending PeerDB Chart to include additional resources
  - `ExternalSecrets` for syncing secrets from a secret manager


# Production Configuration and Best Practices

After following the POC guide from the [QuickStart under README.md](README.md), you can now move on to setting up PeerDB Enterprise in a production environment. This guide will help you understand the best practices and configurations to follow for a production setup.

## Making the `values.yaml` files secure

1. After running the `./install_catalog.sh` and `./install_peerdb.sh` scripts, there should be 2 files available in the root directory of the repository pertaining the two charts that were installed (`peerdb` and `peerdb-catalog`):
   ```shell
   $ ls *.values.secret.yaml
   peerdb-catalog.values.secret.yaml
   peerdb.values.secret.yaml
   ```

2. These two files can now copied over and used to override the default chart values and used directly with the `helm` commands (or indirectly via `helmfile`, ArgoCD, Flux, etc.) to deploy the charts with the desired configurations.

3. Each password can be configured to use an in-cluster kubernetes secret by setting the `existingSecret` key available at the same level as the password key. The secret should have the key `password` with the value as the password. For example:
   ```yaml
   # peerdb/values.customer.yaml
   peerdb:
     catalog:
        existingSecret: peerdb-catalog-secret
   ...
   # peerdb-catalog/values.customer.yaml
   credentials:
     default:
       existingSecret: peerdb-temporal-default-creds-secret
     visibility:
       existingSecret: peerdb-temporal-visibility-creds-secret
     admin:
       existingSecret: peerdb-temporal-admin-creds-secret
     catalog:
       existingSecret: peerdb-catalog-secret
    ```
4. The charts can be further used as subchart dependencies to include more manifests to include configuration like `ExternalSecrets`, `NetworkPolicies`, `PodSecurityPolicies`, etc.


## Examples of production setups

Example production setups can be seen in the [`examples`](examples) directory.


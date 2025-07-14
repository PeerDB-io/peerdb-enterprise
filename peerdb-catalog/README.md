# peerdb-catalog

![Version: 0.8.4](https://img.shields.io/badge/Version-0.8.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.30.7](https://img.shields.io/badge/AppVersion-v0.30.7-informational?style=flat-square)

A Helm chart for Kubernetes

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| PeerDB Inc. |  | <https://peerdb.io/> |
| Kunal Gupta | <kunal@peerdb.io> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://registry.developers.crunchydata.com/crunchydata | pgo | 5.5.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| common.pods.affinity | object | `{}` | affinity that will be applied to all the catalog related services additively |
| common.pods.imagePullSecrets | list | `[]` | image pull secrets that will be applied to all the catalog related services additively |
| common.pods.nodeSelector | object | `{}` | node selector that will be applied to all the catalog related services additively |
| common.pods.tolerations | list | `[]` | tolerations that will be applied to all the catalog related services additively |
| credentials.admin.database | string | `"_TEMPORAL_ADMIN_DATABASE_"` |  |
| credentials.admin.existingSecret | string | `""` | Use an existing secret for the temporal admin user. Use this when saving credentials to values.yaml is not desired |
| credentials.admin.existingSecretEnabledFields.user | bool | `false` | Whether to use the user field from the existing secret |
| credentials.admin.password | string | `"_TEMPORAL_ADMIN_PASSWORD_"` |  |
| credentials.admin.user | string | `"_TEMPORAL_ADMIN_USER_"` |  |
| credentials.catalog.database | string | `"_CATALOG_DATABASE_"` |  |
| credentials.default.database | string | `"_TEMPORAL_DEFAULT_DATABASE_"` |  |
| credentials.default.existingSecret | string | `""` | Use an existing secret for the temporal default user. Use this when saving credentials to values.yaml is not desired |
| credentials.default.existingSecretEnabledFields.user | bool | `false` | Whether to use the user field from the existing secret |
| credentials.default.password | string | `"_TEMPORAL_DEFAULT_PASSWORD_"` |  |
| credentials.default.user | string | `"_TEMPORAL_DEFAULT_USER_"` |  |
| credentials.pgHost | string | `"_PG_HOST_"` |  |
| credentials.pgPort | string | `"_PG_PORT_"` |  |
| credentials.secretName | string | `"_CATALOG_DB_MANUAL_CREDS_NAME_"` |  |
| credentials.ssl.enabled | string | `"_TEMPORAL_SSL_MODE_"` |  |
| credentials.ssl.existingSecret | string | `""` | Use an existing secret for the catalog ssl certificate to use for catalog. Generally used when a custom SSL certificate is needed |
| credentials.ssl.path | string | `"_TEMPORAL_SSL_CA_CERT_PATH_"` |  |
| credentials.ssl.type | string | `"_"` |  |
| credentials.visibility.database | string | `"_TEMPORAL_VISIBILITY_DATABASE_"` |  |
| credentials.visibility.existingSecret | string | `""` | Use an existing secret for the temporal visibility user. Use this when saving credentials to values.yaml is not desired |
| credentials.visibility.existingSecretEnabledFields.user | bool | `false` | Whether to use the user field from the existing secret |
| credentials.visibility.password | string | `"_TEMPORAL_VISIBILITY_PASSWORD_"` |  |
| credentials.visibility.user | string | `"_TEMPORAL_VISIBILITY_USER_"` |  |
| deploy.backups.volume.resources.requests.storage | string | `"384Gi"` | Storage size for the catalog backups, refer to Crunchy PGO for more details |
| deploy.clusterName | string | `"_PG_CLUSTER_NAME_"` |  |
| deploy.enabled | bool | `true` |  |
| deploy.instance.volume.resources.requests.storage | string | `"128Gi"` | Storage size for the catalog instance, refer to Crunchy PGO for more details |
| deploy.replicaCount | int | `3` |  |
| deploy.resources.limits.cpu | int | `2` |  |
| deploy.resources.limits.memory | string | `"2Gi"` |  |
| deploy.resources.requests.cpu | int | `2` |  |
| deploy.resources.requests.memory | string | `"2Gi"` |  |
| deploy.user.options | string | `"SUPERUSER"` |  |
| deploy.version | int | `15` |  |
| global.peerdb.enterprise.saveCustomerValuesAsSecret | string | `"_SAVE_VALUES_AS_SECRET_"` | Whether to save customer values as a kubernetes secret for backup, pulled from `SAVE_VALUES_AS_SECRET` from .env |
| pgo.debug | bool | `true` |  |
| pgo.disable_check_for_upgrades | bool | `false` |  |
| pgo.patroni.allowed_cidr[0] | string | `"0.0.0.0/0"` |  |
| pgo.resources.controller.limits.cpu | int | `1` |  |
| pgo.resources.controller.limits.ephemeral-storage | string | `"2Gi"` |  |
| pgo.resources.controller.limits.memory | string | `"512Mi"` |  |
| pgo.resources.controller.requests.cpu | int | `1` |  |
| pgo.resources.controller.requests.ephemeral-storage | string | `"1Gi"` |  |
| pgo.resources.controller.requests.memory | string | `"512Mi"` |  |
| pgo.singleNamespace | bool | `true` |  |
| schema.create.enabled | bool | `true` |  |
| schema.create.resources.limits.cpu | float | `0.5` |  |
| schema.create.resources.limits.memory | string | `"512Mi"` |  |
| schema.create.resources.requests.cpu | float | `0.5` |  |
| schema.create.resources.requests.memory | string | `"512Mi"` |  |
| schema.resources.limits.cpu | float | `0.5` |  |
| schema.resources.limits.memory | string | `"512Mi"` |  |
| schema.resources.requests.cpu | float | `0.5` |  |
| schema.resources.requests.memory | string | `"512Mi"` |  |
| schema.setup.backoffLimit | int | `100` |  |
| schema.setup.debug | bool | `false` |  |
| schema.setup.enabled | bool | `true` | Whether to enable the schema setup job for temporal, it is recommended to have it enabled |
| schema.setup.hook.enabled | bool | `false` |  |
| schema.setup.pods.init.image.repository | string | `"golang"` |  |
| schema.setup.pods.init.image.tag | string | `"alpine"` |  |
| schema.setup.pods.schemaCreate.repository | string | `"alpine"` |  |
| schema.setup.pods.schemaCreate.tag | string | `"latest"` |  |
| schema.test.image.repository | string | `"postgres"` |  |
| schema.test.image.tag | string | `"latest"` |  |
| schema.update.backoffLimit | int | `100` |  |
| schema.update.enabled | bool | `true` | Whether to enable the schema update job for temporal, it is recommended to have it enabled |
| schema.update.hook.enabled | bool | `true` |  |
| schema.update.hook.type | string | `"pre-upgrade"` |  |
| temporal.admintools.image.pullPolicy | string | `"IfNotPresent"` |  |
| temporal.admintools.image.repository | string | `"temporalio/admin-tools"` |  |
| temporal.admintools.image.tag | string | `"1.24.2.1-tctl-1.18.1-cli-0.13.2"` | This should be set from the helm values for temporal dependency from the main chart |
| temporal.deploy.enabled | bool | `true` |  |
| temporal.tls.enabled | string | `"_TEMPORAL_SSL_MODE_"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

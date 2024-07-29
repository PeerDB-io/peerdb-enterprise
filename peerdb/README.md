# peerdb

![Version: 0.6.0](https://img.shields.io/badge/Version-0.6.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.12.2](https://img.shields.io/badge/AppVersion-v0.12.2-informational?style=flat-square)

Install PeerDB along with Temporal.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| PeerDB Inc. |  | <https://peerdb.io/> |
| Kunal Gupta | <kunal@peerdb.io> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://go.temporal.io/helm-charts | temporal-deploy(temporal) | 0.44.0 |
| https://grafana.github.io/helm-charts | pyroscope | 1.0.3 |
| https://helm.datadoghq.com | datadog(datadog) | 3.52.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| authentication.backendService.peerdbUi.hostPattern | string | `""` |  |
| authentication.backendService.temporal.hostPattern | string | `""` |  |
| authentication.credentials.password | string | `nil` |  |
| authentication.credentials.username | string | `"peerdb-user"` |  |
| authentication.enabled | bool | `false` |  |
| authentication.healthcheck.path | string | `"/health"` |  |
| authentication.healthcheck.script.timeoutSeconds | int | `55` |  |
| authentication.image.pullPolicy | string | `"Always"` |  |
| authentication.image.repository | string | `"nginx"` |  |
| authentication.image.tag | string | `"latest"` |  |
| authentication.replicaCount | int | `4` |  |
| authentication.resources.limits.cpu | float | `0.5` |  |
| authentication.resources.limits.ephemeral-storage | string | `"4Gi"` |  |
| authentication.resources.limits.memory | string | `"256Mi"` |  |
| authentication.resources.requests.cpu | float | `0.1` |  |
| authentication.resources.requests.ephemeral-storage | string | `"4Gi"` |  |
| authentication.resources.requests.memory | string | `"128Mi"` |  |
| authentication.service.annotations | object | `{}` |  |
| authentication.service.port | int | `80` |  |
| authentication.service.targetPort | int | `80` |  |
| authentication.service.type | string | `"LoadBalancer"` |  |
| aws.accessKeyId | string | `nil` |  |
| aws.region | string | `"_AWS_REGION_"` |  |
| aws.roleArn | string | `nil` |  |
| aws.secretAccessKey | string | `nil` |  |
| azure.clientId | string | `nil` |  |
| azure.clientSecret | string | `nil` |  |
| azure.subscriptionId | string | `nil` |  |
| azure.tenantId | string | `nil` |  |
| catalog.credentialsSecretName | string | `"_CATALOG_DB_MANUAL_CREDS_NAME_"` | catalog credentials secret name - autofilled if using in-cluster catalog, else pulled `CATALOG_DB_MANUAL_CREDS_NAME` from .env and is used to create the secret for the catalog, creds are pulled from .env |
| catalog.deploy.clusterName | string | `"catalog-pg-cluster"` |  |
| catalog.deploy.enabled | bool | `false` | Whether to deploy the catalog, pulled from `CATALOG_DEPLOY_ENABLED` from .env |
| catalog.existingSecret | string | `""` | Use an existing secret for catalog credentials. Use this when saving credentials to values.yaml is not desired |
| catalog.pgAdminDatabase | string | `"_PG_ADMIN_DATABASE_"` | catalog admin database - autofilled if using in-cluster catalog, else pulled from .env |
| catalog.pgDatabase | string | `"_PG_DATABASE_"` | catalog database - autofilled if using in-cluster catalog, else pulled from .env |
| catalog.pgHost | string | `"_PG_HOST_"` | catalog host - autofilled if using in-cluster catalog, else pulled from .env |
| catalog.pgPassword | string | `"_PG_PASSWORD_"` | catalog password - autofilled if using in-cluster catalog, else pulled from .env |
| catalog.pgPort | string | `"_PG_PORT_"` | catalog port - autofilled if using in-cluster catalog, else pulled from .env |
| catalog.pgUser | string | `"_PG_USER_"` | catalog user - autofilled if using in-cluster catalog, else pulled from .env |
| common | object | `{"pods":{"affinity":{},"imagePullSecrets":[],"nodeSelector":{},"tolerations":[]}}` | Common values for all peerdb components that will be merged with the specific component values |
| common.pods.affinity | object | `{}` | Affinity that will be applied to all the peerdb components additively |
| common.pods.imagePullSecrets | list | `[]` | Image pull secrets that will be applied to all the peerdb components additively |
| common.pods.nodeSelector | object | `{}` | Node selector that will be applied to all the peerdb components additively |
| common.pods.tolerations | list | `[]` | Tolerations that will be applied to all the peerdb components additively |
| datadog.clusterAgent.createPodDisruptionBudget | bool | `true` |  |
| datadog.clusterAgent.enabled | bool | `true` |  |
| datadog.clusterAgent.replicas | int | `2` |  |
| datadog.datadog.apiKey | string | `"_DATADOG_API_KEY_"` | datadog api key, pulled from `DATADOG_API_KEY` from .env |
| datadog.datadog.clusterName | string | `"_DATADOG_CLUSTER_NAME_"` | datadog cluster name, pulled from `DATADOG_CLUSTER_NAME` from .env |
| datadog.datadog.containerExclude | string | `"kube_namespace:.*"` |  |
| datadog.datadog.containerInclude | string | `"kube_namespace:_PEERDB_K8S_NAMESPACE_"` |  |
| datadog.datadog.logs.containerCollectAll | bool | `true` |  |
| datadog.datadog.logs.enabled | bool | `true` |  |
| datadog.datadog.networkMonitoring.enabled | bool | `true` |  |
| datadog.datadog.site | string | `"_DATADOG_SITE_"` | datadog site, pulled from `DATADOG_SITE` from .env |
| datadog.datadog.tags[0] | string | `"peerdb.io/cluster-for:enterprise"` |  |
| datadog.enabled | string | `"_DATADOG_ENABLED_"` | Whether to deploy datadog, pulled from `DATADOG_ENABLED` from .env |
| flowApi.deployment.annotations | object | `{}` | annotations that will be applied to the flowApi deployment, NOT the pods |
| flowApi.deployment.labels | object | `{}` | labels that will be applied to the flowApi deployment, NOT the pods |
| flowApi.enabled | bool | `true` |  |
| flowApi.extraEnv | list | `[]` |  |
| flowApi.image.pullPolicy | string | `"Always"` |  |
| flowApi.image.repository | string | `"ghcr.io/peerdb-io/flow-api"` |  |
| flowApi.lowCost | bool | `true` |  |
| flowApi.pods.affinity | object | `{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchExpressions":[{"key":"app","operator":"In","values":["flow-api"]}]},"topologyKey":"topology.kubernetes.io/zone"},"weight":100}]}}` | flowApi pod affinity, the default is to schedule flowApi pods on different nodes than other flowApi pods for High Availability |
| flowApi.pods.annotations | object | `{}` | annotations that will be applied to all flowApi pods, NOT the deployment |
| flowApi.pods.labels | object | `{}` | labels that will be applied to all flowApi pods, NOT the deployment |
| flowApi.pods.nodeSelector | object | `{}` |  |
| flowApi.pods.tolerations | list | `[]` |  |
| flowApi.replicaCount | int | `4` |  |
| flowApi.resources.limits.cpu | float | `0.5` |  |
| flowApi.resources.limits.ephemeral-storage | string | `"4Gi"` |  |
| flowApi.resources.limits.memory | string | `"256Mi"` |  |
| flowApi.resources.requests.cpu | float | `0.1` |  |
| flowApi.resources.requests.ephemeral-storage | string | `"4Gi"` |  |
| flowApi.resources.requests.memory | string | `"128Mi"` |  |
| flowApi.service.annotations | object | `{}` |  |
| flowApi.service.enabled | bool | `true` |  |
| flowApi.service.httpPort | int | `8113` |  |
| flowApi.service.port | int | `8112` |  |
| flowApi.service.targetHttpPort | int | `8113` |  |
| flowApi.service.targetPort | int | `8112` |  |
| flowApi.service.type | string | `"ClusterIP"` |  |
| flowSnapshotWorker.enabled | bool | `true` |  |
| flowSnapshotWorker.extraEnv | list | `[]` |  |
| flowSnapshotWorker.image.pullPolicy | string | `"Always"` |  |
| flowSnapshotWorker.image.repository | string | `"ghcr.io/peerdb-io/flow-snapshot-worker"` |  |
| flowSnapshotWorker.lowCost | bool | `true` |  |
| flowSnapshotWorker.pods.affinity | object | `{}` |  |
| flowSnapshotWorker.pods.annotations | object | `{}` | annotations that will be applied to all flowSnapshotWorker pods, NOT the statefulSet |
| flowSnapshotWorker.pods.labels | object | `{}` | labels that will be applied to all flowSnapshotWorker pods, NOT the statefulSet |
| flowSnapshotWorker.pods.nodeSelector | object | `{}` |  |
| flowSnapshotWorker.pods.tolerations | list | `[]` |  |
| flowSnapshotWorker.replicaCount | int | `1` |  |
| flowSnapshotWorker.resources.limits.cpu | int | `1` |  |
| flowSnapshotWorker.resources.limits.ephemeral-storage | string | `"16Gi"` |  |
| flowSnapshotWorker.resources.limits.memory | string | `"1Gi"` |  |
| flowSnapshotWorker.resources.requests.cpu | float | `0.5` |  |
| flowSnapshotWorker.resources.requests.ephemeral-storage | string | `"10Gi"` |  |
| flowSnapshotWorker.resources.requests.memory | string | `"1Gi"` |  |
| flowSnapshotWorker.service.annotations | object | `{}` |  |
| flowSnapshotWorker.service.enabled | bool | `true` |  |
| flowSnapshotWorker.statefulSet.annotations | object | `{}` | annotations that will be applied to the flowSnapshotWorker statefulSet, NOT the pods |
| flowSnapshotWorker.statefulSet.labels | object | `{}` | labels that will be applied to the flowSnapshotWorker statefulSet, NOT the pods |
| flowWorker.deployment.annotations | object | `{}` | annotations that will be applied to the flowWorker deployment, NOT the pods |
| flowWorker.deployment.labels | object | `{}` | labels that will be applied to the flowWorker deployment, NOT the pods |
| flowWorker.enabled | bool | `true` |  |
| flowWorker.extraEnv | list | `[]` |  |
| flowWorker.image.pullPolicy | string | `"Always"` |  |
| flowWorker.image.repository | string | `"ghcr.io/peerdb-io/flow-worker"` |  |
| flowWorker.lowCost | bool | `false` |  |
| flowWorker.pods.affinity | object | `{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchExpressions":[{"key":"app","operator":"In","values":["flow-worker"]}]},"topologyKey":"topology.kubernetes.io/zone"},"weight":100}]}}` | flowWorker pod affinity, the default is to schedule flowWorker pods on different nodes than other flowWorker pods for High Availability |
| flowWorker.pods.annotations | object | `{}` | annotations that will be applied to all flowWorker pods, NOT the deployment |
| flowWorker.pods.labels | object | `{}` | labels that will be applied to all flowWorker pods, NOT the deployment |
| flowWorker.pods.nodeSelector | object | `{}` |  |
| flowWorker.pods.tolerations | list | `[]` |  |
| flowWorker.replicaCount | int | `2` |  |
| flowWorker.resources.limits.cpu | int | `4` |  |
| flowWorker.resources.limits.ephemeral-storage | string | `"128Gi"` |  |
| flowWorker.resources.limits.memory | string | `"8Gi"` |  |
| flowWorker.resources.requests.cpu | int | `2` |  |
| flowWorker.resources.requests.ephemeral-storage | string | `"64Gi"` |  |
| flowWorker.resources.requests.memory | string | `"8Gi"` |  |
| global.peerdb.enterprise.saveCustomerValuesAsSecret | string | `"_SAVE_VALUES_AS_SECRET_"` | Whether to save customer values as a kubernetes secret for backup, pulled from `SAVE_VALUES_AS_SECRET` from .env |
| global.peerdb.lowCost.affinity | object | `{}` | Affinity that will be applied to all the lowCost=true peerdb components additively |
| global.peerdb.lowCost.nodeSelector | object | `{}` | Node selector that will be applied to all the lowCost=true peerdb components additively |
| global.peerdb.lowCost.tolerations | list | `[]` | Tolerations that will be applied to all the lowCost=true peerdb components additively |
| peerdb.credentials.password | string | `"peerdb"` |  |
| peerdb.deployment.annotations | object | `{}` | annotations that will be applied to the peerdb-server deployment, NOT the pods |
| peerdb.deployment.labels | object | `{}` | labels that will be applied to the peerdb-server deployment, NOT the pods |
| peerdb.enabled | bool | `true` |  |
| peerdb.env.logDir | string | `"/var/log/peerdb"` |  |
| peerdb.extraEnv | list | `[]` |  |
| peerdb.image.pullPolicy | string | `"Always"` |  |
| peerdb.image.repository | string | `"ghcr.io/peerdb-io/peerdb-server"` |  |
| peerdb.lowCost | bool | `true` |  |
| peerdb.pods.affinity | object | `{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchExpressions":[{"key":"app","operator":"In","values":["peerdb-server"]}]},"topologyKey":"topology.kubernetes.io/zone"},"weight":100}]}}` | peerdb pod affinity, the default is to schedule peerdb pods on different nodes than other peerdb pods for High Availability |
| peerdb.pods.annotations | object | `{}` | annotations that will be applied to the peerdb-server pods, NOT the deployment |
| peerdb.pods.labels | object | `{}` | labels that will be applied to the peerdb-server pods, NOT the deployment |
| peerdb.pods.nodeSelector | object | `{}` |  |
| peerdb.pods.tolerations | list | `[]` |  |
| peerdb.replicaCount | int | `4` |  |
| peerdb.resources.limits.cpu | float | `0.5` |  |
| peerdb.resources.limits.ephemeral-storage | string | `"4Gi"` |  |
| peerdb.resources.limits.memory | string | `"256Mi"` |  |
| peerdb.resources.requests.cpu | float | `0.1` |  |
| peerdb.resources.requests.ephemeral-storage | string | `"4Gi"` |  |
| peerdb.resources.requests.memory | string | `"128Mi"` |  |
| peerdb.service.annotations | object | `{}` |  |
| peerdb.service.enabled | bool | `true` |  |
| peerdb.service.name | string | `"peerdb-server"` |  |
| peerdb.service.port | int | `9900` |  |
| peerdb.service.targetPort | int | `9900` |  |
| peerdb.service.type | string | `"ClusterIP"` |  |
| peerdb.version | string | `"stable-v0.12.1"` |  |
| peerdbUI.credentials.nexauth_secret | string | `""` |  |
| peerdbUI.credentials.password | string | `"_PEERDB_PASSWORD_"` |  |
| peerdbUI.deployment.annotations | object | `{}` | annotations that will be applied to the peerdbUI deployment, NOT the pods |
| peerdbUI.deployment.labels | object | `{}` | labels that will be applied to the peerdbUI deployment, NOT the pods |
| peerdbUI.enabled | bool | `true` |  |
| peerdbUI.extraEnv | list | `[]` |  |
| peerdbUI.image.pullPolicy | string | `"Always"` |  |
| peerdbUI.image.repository | string | `"ghcr.io/peerdb-io/peerdb-ui"` |  |
| peerdbUI.ingress.annotations | object | `{}` |  |
| peerdbUI.ingress.className | string | `""` |  |
| peerdbUI.ingress.enabled | bool | `false` |  |
| peerdbUI.ingress.hosts | list | `[{"host":"","paths":[{"path":"/"}]}]` | List of Hosts for the Ingress |
| peerdbUI.ingress.hosts[0] | object | `{"host":"","paths":[{"path":"/"}]}` | Host of the ingress, non-empty |
| peerdbUI.ingress.hosts[0].paths | list | `[{"path":"/"}]` | Paths within the host |
| peerdbUI.ingress.hosts[0].paths[0] | object | `{"path":"/"}` | Path within the host, non-empty |
| peerdbUI.ingress.tls | list | `[]` | TLS configuration for ingress. Eg: `[ { hosts: [ "example.com" ], secretName: "example-tls" } ]` |
| peerdbUI.lowCost | bool | `true` |  |
| peerdbUI.pods.affinity | object | `{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchExpressions":[{"key":"app","operator":"In","values":["peerdb-ui"]}]},"topologyKey":"topology.kubernetes.io/zone"},"weight":100}]}}` | peerdbUI pod affinity, the default is to schedule peerdbUI pods on different nodes than other peerdbUI pods for High Availability |
| peerdbUI.pods.annotations | object | `{}` | annotations that will be applied to all peerdbUI pods, NOT the deployment |
| peerdbUI.pods.labels | object | `{}` | labels that will be applied to all peerdbUI pods, NOT the deployment |
| peerdbUI.pods.nodeSelector | object | `{}` |  |
| peerdbUI.pods.tolerations | list | `[]` |  |
| peerdbUI.replicaCount | int | `4` |  |
| peerdbUI.resources.limits.cpu | float | `0.5` |  |
| peerdbUI.resources.limits.ephemeral-storage | string | `"4Gi"` |  |
| peerdbUI.resources.limits.memory | string | `"512Mi"` |  |
| peerdbUI.resources.requests.cpu | float | `0.1` |  |
| peerdbUI.resources.requests.ephemeral-storage | string | `"4Gi"` |  |
| peerdbUI.resources.requests.memory | string | `"256Mi"` |  |
| peerdbUI.service.annotations | object | `{}` |  |
| peerdbUI.service.enabled | bool | `true` |  |
| peerdbUI.service.port | int | `3000` |  |
| peerdbUI.service.targetPort | int | `3000` |  |
| peerdbUI.service.type | string | `"LoadBalancer"` |  |
| peerdbUI.service.url | string | `"_PEERDB_UI_SERVICE_URL_"` |  |
| pyroscope.enabled | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `nil` |  |
| temporal-deploy.admintools.resources.limits.cpu | string | `"500m"` |  |
| temporal-deploy.admintools.resources.limits.memory | string | `"256Mi"` |  |
| temporal-deploy.admintools.resources.requests.cpu | string | `"100m"` |  |
| temporal-deploy.admintools.resources.requests.memory | string | `"128Mi"` |  |
| temporal-deploy.cassandra.enabled | bool | `false` |  |
| temporal-deploy.elasticsearch.enabled | bool | `false` |  |
| temporal-deploy.grafana.enabled | bool | `false` |  |
| temporal-deploy.mysql.enabled | bool | `false` |  |
| temporal-deploy.prometheus.enabled | bool | `false` |  |
| temporal-deploy.schema.createDatabase.enabled | bool | `false` |  |
| temporal-deploy.schema.setup.enabled | bool | `false` |  |
| temporal-deploy.schema.update.enabled | bool | `false` |  |
| temporal-deploy.server.config.persistence.default.driver | string | `"sql"` |  |
| temporal-deploy.server.config.persistence.default.sql.database | string | `"temporal"` |  |
| temporal-deploy.server.config.persistence.default.sql.driver | string | `"postgres12"` |  |
| temporal-deploy.server.config.persistence.default.sql.host | string | `"_HOST_"` |  |
| temporal-deploy.server.config.persistence.default.sql.maxConnLifetime | string | `"1h"` |  |
| temporal-deploy.server.config.persistence.default.sql.maxConns | int | `20` |  |
| temporal-deploy.server.config.persistence.default.sql.password | string | `"_PASSWORD_"` |  |
| temporal-deploy.server.config.persistence.default.sql.port | int | `5432` |  |
| temporal-deploy.server.config.persistence.default.sql.tls.enabled | string | `"_TEMPORAL_SSL_MODE_"` |  |
| temporal-deploy.server.config.persistence.default.sql.user | string | `"_USERNAME_"` |  |
| temporal-deploy.server.config.persistence.visibility.driver | string | `"sql"` |  |
| temporal-deploy.server.config.persistence.visibility.sql.database | string | `"temporal_visibility"` |  |
| temporal-deploy.server.config.persistence.visibility.sql.driver | string | `"postgres12"` |  |
| temporal-deploy.server.config.persistence.visibility.sql.host | string | `"_HOST_"` |  |
| temporal-deploy.server.config.persistence.visibility.sql.maxConnLifetime | string | `"1h"` |  |
| temporal-deploy.server.config.persistence.visibility.sql.maxConns | int | `20` |  |
| temporal-deploy.server.config.persistence.visibility.sql.password | string | `"_PASSWORD_"` |  |
| temporal-deploy.server.config.persistence.visibility.sql.port | int | `5432` |  |
| temporal-deploy.server.config.persistence.visibility.sql.tls.enabled | string | `"_TEMPORAL_SSL_MODE_"` |  |
| temporal-deploy.server.config.persistence.visibility.sql.user | string | `"_USERNAME_"` |  |
| temporal-deploy.server.dynamicConfig."frontend.enableUpdateWorkflowExecution"[0].value | bool | `true` |  |
| temporal-deploy.server.dynamicConfig."limit.maxIDLength"[0].constraints | object | `{}` |  |
| temporal-deploy.server.dynamicConfig."limit.maxIDLength"[0].value | int | `255` |  |
| temporal-deploy.server.frontend.affinity | object | `{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchExpressions":[{"key":"app.kubernetes.io/name","operator":"In","values":["temporal-deploy"]},{"key":"app.kubernetes.io/component","operator":"In","values":["web"]}]},"topologyKey":"topology.kubernetes.io/zone"},"weight":100}]}}` | `frontend` pod affinity, the default is to schedule frontend pods on different nodes than other frontend pods for High Availability |
| temporal-deploy.server.frontend.replicaCount | int | `1` |  |
| temporal-deploy.server.frontend.resources.limits.cpu | float | `1.5` |  |
| temporal-deploy.server.frontend.resources.limits.memory | string | `"1.5Gi"` |  |
| temporal-deploy.server.frontend.resources.requests.cpu | int | `1` |  |
| temporal-deploy.server.frontend.resources.requests.memory | string | `"1Gi"` |  |
| temporal-deploy.server.history.affinity | object | `{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchExpressions":[{"key":"app.kubernetes.io/name","operator":"In","values":["temporal-deploy"]},{"key":"app.kubernetes.io/component","operator":"In","values":["history"]}]},"topologyKey":"topology.kubernetes.io/zone"},"weight":100}]}}` | `history` pod affinity, the default is to schedule history pods on different nodes than other history pods for High Availability |
| temporal-deploy.server.history.replicaCount | int | `1` |  |
| temporal-deploy.server.history.resources.limits.cpu | int | `2` |  |
| temporal-deploy.server.history.resources.limits.memory | string | `"2Gi"` |  |
| temporal-deploy.server.history.resources.requests.cpu | int | `1` |  |
| temporal-deploy.server.history.resources.requests.memory | string | `"1.5Gi"` |  |
| temporal-deploy.server.matching.affinity | object | `{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchExpressions":[{"key":"app.kubernetes.io/name","operator":"In","values":["temporal-deploy"]},{"key":"app.kubernetes.io/component","operator":"In","values":["matching"]}]},"topologyKey":"topology.kubernetes.io/zone"},"weight":100}]}}` | `matching` pod affinity, the default is to schedule matching pods on different nodes than other matching pods for High Availability |
| temporal-deploy.server.matching.replicaCount | int | `1` |  |
| temporal-deploy.server.matching.resources.limits.cpu | float | `1.5` |  |
| temporal-deploy.server.matching.resources.limits.memory | string | `"1.5Gi"` |  |
| temporal-deploy.server.matching.resources.requests.cpu | int | `1` |  |
| temporal-deploy.server.matching.resources.requests.memory | string | `"1Gi"` |  |
| temporal-deploy.server.replicaCount | int | `1` |  |
| temporal-deploy.server.resources.limits.cpu | int | `4` |  |
| temporal-deploy.server.resources.limits.memory | string | `"4Gi"` |  |
| temporal-deploy.server.resources.requests.cpu | int | `2` |  |
| temporal-deploy.server.resources.requests.memory | string | `"2Gi"` |  |
| temporal-deploy.server.worker.affinity | object | `{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchExpressions":[{"key":"app.kubernetes.io/name","operator":"In","values":["temporal-deploy"]},{"key":"app.kubernetes.io/component","operator":"In","values":["worker"]}]},"topologyKey":"topology.kubernetes.io/zone"},"weight":100}]}}` | `worker` pod affinity, the default is to schedule worker pods on different nodes than other worker pods for High Availability |
| temporal-deploy.server.worker.replicaCount | int | `1` |  |
| temporal-deploy.server.worker.resources.limits.cpu | float | `1.5` |  |
| temporal-deploy.server.worker.resources.limits.memory | string | `"1.5Gi"` |  |
| temporal-deploy.server.worker.resources.requests.cpu | int | `1` |  |
| temporal-deploy.server.worker.resources.requests.memory | string | `"1Gi"` |  |
| temporal-deploy.web.affinity | object | `{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchExpressions":[{"key":"app.kubernetes.io/name","operator":"In","values":["temporal-deploy"]},{"key":"app.kubernetes.io/component","operator":"In","values":["web"]}]},"topologyKey":"topology.kubernetes.io/zone"},"weight":100}]}}` | `web` pod affinity, the default is to schedule web pods on different nodes than other web pods for High Availability |
| temporal-deploy.web.image.tag | string | `"2.22.2"` |  |
| temporal-deploy.web.replicaCount | int | `1` |  |
| temporal-deploy.web.resources.limits.cpu | int | `1` |  |
| temporal-deploy.web.resources.limits.memory | string | `"1Gi"` |  |
| temporal-deploy.web.resources.requests.cpu | string | `"100m"` |  |
| temporal-deploy.web.resources.requests.memory | string | `"512Mi"` |  |
| temporal.clientCert | string | `"_PEERDB_TEMPORAL_CLIENT_CERT_"` |  |
| temporal.clientKey | string | `"_PEERDB_TEMPORAL_CLIENT_KEY_"` |  |
| temporal.deploy.enabled | bool | `true` | Whether to deploy temporal, pulled from `TEMPORAL_DEPLOY_ENABLED` from .env |
| temporal.deploy.mirrorNameSearchAttribute.backoffLimit | int | `100` |  |
| temporal.deploy.mirrorNameSearchAttribute.resources.limits.cpu | float | `0.5` |  |
| temporal.deploy.mirrorNameSearchAttribute.resources.limits.memory | string | `"256Mi"` |  |
| temporal.deploy.mirrorNameSearchAttribute.resources.requests.cpu | float | `0.1` |  |
| temporal.deploy.mirrorNameSearchAttribute.resources.requests.memory | string | `"128Mi"` |  |
| temporal.deploy.registerNamespace.backoffLimit | int | `100` |  |
| temporal.deploy.registerNamespace.resources.limits.cpu | float | `0.5` |  |
| temporal.deploy.registerNamespace.resources.limits.ephemeral-storage | string | `"4Gi"` |  |
| temporal.deploy.registerNamespace.resources.limits.memory | string | `"256Mi"` |  |
| temporal.deploy.registerNamespace.resources.requests.cpu | float | `0.1` |  |
| temporal.deploy.registerNamespace.resources.requests.ephemeral-storage | string | `"4Gi"` |  |
| temporal.deploy.registerNamespace.resources.requests.memory | string | `"128Mi"` |  |
| temporal.host | string | `"peerdb-temporal-frontend"` |  |
| temporal.k8s_namespace | string | `"_PEERDB_TEMPORAL_K8S_NAMESPACE_"` |  |
| temporal.namespace | string | `"default"` |  |
| temporal.port | int | `7233` |  |
| temporal.releaseName | string | `"_PEERDB_TEMPORAL_RELEASE_NAME_"` |  |
| temporal.taskQueueId | string | `"_PEERDB_DEPLOYMENT_UID_"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

{{- define "catalog.secretName" -}}
{{- .Values.credentials.secretName }}
{{- end -}}

{{- define "catalog.deployed.secretName" -}}
{{ printf "%s-%s-%s" (.Values.deploy.clusterName) "pguser" (.Values.catalog.pgUser) }}
{{- end -}}

{{- define "catalog.secretNameToUse" -}}
{{- if .Values.deploy.enabled -}}
{{/* The secret with given keys is auto-generated by the operator if we seek to use it, else we create ourselves*/}}
{{- include "catalog.deployed.secretName" . -}}
{{- else -}}
{{- include "catalog.secretName" . -}}
{{- end -}}
{{- end -}}

{{- define "deploy.postgres.name" -}}
{{ .Values.deploy.clusterName }}
{{- end -}}
{{- define "deploy.postgres.cluster.name" -}}
{{ .Values.deploy.clusterName }}
{{- end -}}
{{- define "deploy.schema.create.config.name" -}}
{{ .Values.deploy.clusterName }}-create-schema
{{- end -}}


{{- define "catalog.ssl.certificate.defaultSecretName" -}}
catalog-ssl-certificate
{{- end -}}



{{- define "catalog.ssl.certificate.secretName" -}}
{{- if not .Values.credentials.ssl.existingSecret }}
{{- include "catalog.ssl.certificate.defaultSecretName" . -}}
{{- else -}}
{{- .Values.credentials.ssl.existingSecret }}
{{- end -}}
{{- end -}}
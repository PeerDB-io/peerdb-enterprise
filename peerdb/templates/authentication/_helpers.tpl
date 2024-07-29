{{- define "authentication.peerdb-ui.service.fqdn-with-port" -}}
peerdb-ui.{{ .Release.Namespace }}.svc.cluster.local:{{ .Values.peerdbUI.service.port }}
{{- end -}}

{{- define "authentication.peerdb.service.fqdn-with-port" -}}
{{ .Values.peerdb.service.name }}.{{ .Release.Namespace }}.svc.cluster.local:{{ .Values.peerdb.service.port }}
{{- end -}}

{{- define "authentication.temporal.service.fqdn-with-port" -}}
{{ .Values.temporal.releaseName }}-web.{{ .Release.Namespace }}.svc.cluster.local:8080
{{- end -}}

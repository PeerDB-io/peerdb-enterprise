{{- define "authentication.config.data" -}}
events {
    worker_connections  4096;
}

http {
    resolver kube-dns.kube-system.svc.cluster.local valid=10s; # Verify resolution works
    # TODO remove port hardcoding for temporal once we have unified chart
    map $http_host $backend_service {
        {{ .Values.authentication.backendService.peerdbUi.hostPattern | default `~^peerdb-ui\..*` }}             "{{- include "authentication.peerdb-ui.service.fqdn-with-port" . -}}";
        {{- if .Values.temporal.deploy.enabled }}
        {{ .Values.authentication.backendService.temporal.hostPattern |  default `~^temporal\..*` }}             "{{- include "authentication.temporal.service.fqdn-with-port" . -}}";
        {{- end }}
    }

    access_log /dev/stdout combined;
    error_log /dev/stdout;
    server {
        listen {{ .Values.authentication.service.targetPort }};
        root   /usr/share/nginx/html;
        location / {
            auth_basic           "Authentication required";
            auth_basic_user_file /secrets/htpasswd/htpasswd;

            proxy_pass http://$backend_service;
        }
        location = {{ .Values.authentication.healthcheck.path }} {
            access_log off;
            add_header 'Content-Type' 'application/json';
            return 200 '{"status":"UP"}';
        }
    }

}

stream {
    log_format basic '$remote_addr [$time_local] '
                     '$protocol $status $bytes_sent $bytes_received '
                     '$session_time';
    access_log /dev/stdout basic;
    error_log /dev/stdout;
    server {
        listen {{ .Values.peerdb.service.port }};
        proxy_pass "{{- include "authentication.peerdb.service.fqdn-with-port" . -}}";
       # TODO take a look at TCP healthcheck
{{/*        location = {{ .Values.authentication.healthcheck.path }} {*/}}
{{/*            access_log off;*/}}
{{/*            add_header 'Content-Type' 'application/json';*/}}
{{/*            return 200 '{"status":"UP"}';*/}}
{{/*        }*/}}
    }

}

{{- end -}}

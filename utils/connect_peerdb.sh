#!/bin/bash
set -Exeuo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source .env file in parent directory
set -a
source "${SCRIPT_DIR}/../.env"
set +a

get_service_ip_or_hostname() {
    local namespace="$1"
    local service_name="$2"
    local hostname=$(kubectl get service "$service_name" -n "$namespace" -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    local ip=$(kubectl get service "$service_name" -n "$namespace" -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    if [[ -n "$hostname" ]]; then
        echo "$hostname"
    elif [[ -n "$ip" ]]; then
        echo "$ip"
    else
        echo "Neither IP nor hostname could be retrieved for service: $service_name" >&2
        exit 1
    fi
}

ip=$(get_service_ip_or_hostname ${PEERDB_K8S_NAMESPACE} peerdb-server)
port=$(kubectl get service peerdb-server -n ${PEERDB_K8S_NAMESPACE} -o jsonpath='{.spec.ports[0].port}')

psql "host=${ip} port=${port} user=peerdb password=${PEERDB_PASSWORD} dbname=peerdb"

#!/usr/bin/env bash
set -Eeuo pipefail


function wait_for_pg_ready() {
  kubectl wait --timeout=300s --for=condition=ready -n "${PEERDB_K8S_NAMESPACE}" pod -l "postgres-operator.crunchydata.com/cluster=${CATALOG_DEPLOY_CLUSTER_NAME}" -l "postgres-operator.crunchydata.com/role=master"
}

# We have to setup a tunnel service for postgres because of no selector and then port forward
function port_forward_k8s_pg() {
  NEW_PORT=$1
  wait_for_pg_ready
  tunnel_name="pg-tunnel-$USER-$RANDOM"
  kubectl -n "${PEERDB_K8S_NAMESPACE}" run "${tunnel_name}" --image=alpine/socat tcp-listen:5432,fork,reuseaddr "tcp-connect:${CATALOG_DEPLOY_CLUSTER_NAME}-primary:${PG_PORT}" &
  tunel_pid=$!
  function del_tunnel() {
    echo deleting TUNNEL
    kubectl delete -n "${PEERDB_K8S_NAMESPACE}" "pods/${tunnel_name}"
  }
  trap del_tunnel EXIT
  echo Waiting for tunnel to get ready
  sleep 3
  echo Tunnel is ready
  kubectl wait --for=condition=ready -n "${PEERDB_K8S_NAMESPACE}" pod -l run="${tunnel_name}"
  kubectl port-forward -n "${PEERDB_K8S_NAMESPACE}" "pods/${tunnel_name}" $NEW_PORT:5432 & #> /dev/null 2>&1 &
  port_forward_pid=$!
  # kill the port-forward regardless of how this script exits
  function kill_forward() {
    del_tunnel
    echo killing PORT_FORWARD
    kill $port_forward_pid
  }
  trap kill_forward EXIT

  while ! nc -vz localhost $NEW_PORT > /dev/null 2>&1 ; do
      echo "Waiting for port forward to become available"
      sleep 1
  done
}


function check_catalog_deploy() {
  if [[ "$CATALOG_DEPLOY_ENABLED" == "true" ]]; then
    NEW_PORT=$(( ( RANDOM )  + 1024 ))
    port_forward_k8s_pg $NEW_PORT
    export PG_PASSWORD=$(kubectl get secrets -n "${PEERDB_K8S_NAMESPACE}" "${CATALOG_DEPLOY_CLUSTER_NAME}-pguser-${PG_USER}" -o jsonpath='{.data.password}' | base64 -d )
    export TEMPORAL_PASSWORD=$(kubectl get secrets -n "${PEERDB_K8S_NAMESPACE}" "${CATALOG_DEPLOY_CLUSTER_NAME}-pguser-${TEMPORAL_USER}" -o jsonpath='{.data.password}' | base64 -d )
    export PG_PORT="$NEW_PORT"
    export PG_HOST="localhost"
  fi
}

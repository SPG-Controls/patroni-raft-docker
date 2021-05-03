#!/bin/sh

readonly PATRONI_SCOPE=${PATRONI_SCOPE:-batman}
PATRONI_NAMESPACE=${PATRONI_NAMESPACE:-/service}
readonly PATRONI_NAMESPACE=${PATRONI_NAMESPACE%/}
readonly DOCKER_IP=$(hostname --ip-address)

# Patroni settings
export PATRONI_SCOPE
export PATRONI_NAMESPACE
export PATRONI_NAME="${PATRONI_NAME:-$(hostname)}"

# REST API settings
export PATRONI_RESTAPI_CONNECT_ADDRESS=$PATRONI_NAME:8008
export PATRONI_RESTAPI_LISTEN=0.0.0.0:8008

# Raft settings
export PATRONI_RAFT_SELF_ADDR=$PATRONI_NAME:2222
export PATRONI_RAFT_BIND_ADDR=0.0.0.0:2222
export PATRONI_RAFT_DATA_DIR=/app/data/raft

# PostgreSQL settings
export PATRONI_POSTGRESQL_CONNECT_ADDRESS=$PATRONI_NAME:5432
export PATRONI_POSTGRESQL_LISTEN=0.0.0.0:5432
export PATRONI_REPLICATION_USERNAME="${PATRONI_REPLICATION_USERNAME:-replicator}"
export PATRONI_REPLICATION_PASSWORD="${PATRONI_REPLICATION_PASSWORD:-replicate}"
export PATRONI_SUPERUSER_USERNAME="${PATRONI_SUPERUSER_USERNAME:-postgres}"
export PATRONI_SUPERUSER_PASSWORD="${PATRONI_SUPERUSER_PASSWORD:-postgres}"
export PATRONI_REWIND_USERNAME="${PATRONI_REWIND_USERNAME:-postgres}"
export PATRONI_REWIND_PASSWORD="${PATRONI_REWIND_PASSWORD:-postgres}"
export PATRONI_POSTGRESQL_DATA_DIR=/app/data/postgres
export PATRONI_POSTGRESQL_PGPASS=/tmp/pgpass0

# Time to wait for other nodes to start up
# If patroni is started immediately the DNS lookup for other nodes fails
readonly INIT_WAIT_TIME="${INIT_WAIT_TIME:-20}"

echo HOSTNAME:                           $PATRONI_NAME
echo PATRONI_RESTAPI_CONNECT_ADDRESS:    $PATRONI_RESTAPI_CONNECT_ADDRESS
echo PATRONI_RAFT_SELF_ADDR:             $PATRONI_RAFT_SELF_ADDR
echo PATRONI_POSTGRESQL_CONNECT_ADDRESS: $PATRONI_POSTGRESQL_CONNECT_ADDRESS
echo PATRONI_POSTGRESQL_DATA_DIR:        $PATRONI_POSTGRESQL_DATA_DIR

# Stops patroni starting and immediately getting a DNS resolution error
# because other services have not started
echo Waiting $INIT_WAIT_TIME seconds for other nodes to start...
sleep $INIT_WAIT_TIME

echo Starting Patroni
exec python3 -m patroni postgres.yml

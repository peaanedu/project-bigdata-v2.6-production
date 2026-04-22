#!/usr/bin/env bash
set -euo pipefail

export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-/opt/hadoop/etc/hadoop}
export HIVE_CONF_DIR=${HIVE_CONF_DIR:-/opt/hive/conf}

for i in {1..60}; do
  bash -lc 'exec 3<>/dev/tcp/hive-metastore/9083' >/dev/null 2>&1 && break
  echo "Waiting for Hive metastore... ($i/60)"
  sleep 3
done

exec /entrypoint.sh

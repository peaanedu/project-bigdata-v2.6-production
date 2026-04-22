#!/usr/bin/env bash
set -euo pipefail

export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-/opt/hadoop/etc/hadoop}
export HIVE_CONF_DIR=${HIVE_CONF_DIR:-/opt/hive/conf}

for i in {1..60}; do
  pg_isready -h postgres -p 5432 -U "${POSTGRES_USER:-hive}" -d "${POSTGRES_DB:-metastore}" >/dev/null 2>&1 && break
  echo "Waiting for PostgreSQL... ($i/60)"
  sleep 2
done

if schematool -dbType postgres -info >/tmp/hive_schema_info.log 2>&1; then
  echo "Hive metastore schema already present."
else
  echo "Initializing Hive metastore schema..."
  schematool -dbType postgres -initSchema --verbose || schematool -dbType postgres -upgradeSchema --verbose
fi

exec /entrypoint.sh

#!/bin/bash
set -e

echo "Starting HiveServer2..."
export HIVE_AUX_JARS_PATH=/opt/hive/lib/postgresql.jar

until nc -z hive-metastore 9083; do
  echo "Waiting for Hive Metastore..."
  sleep 5
done

exec /opt/hive/bin/hive --service hiveserver2
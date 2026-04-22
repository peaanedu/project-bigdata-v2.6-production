#!/usr/bin/env bash
set -euo pipefail
for i in {1..60}; do
  if docker compose exec -T namenode hdfs dfs -ls / >/dev/null 2>&1; then
    break
  fi
  echo "Waiting for HDFS... ($i/60)"
  sleep 5
done

docker compose exec -T namenode hdfs dfs -mkdir -p /data/raw/sales || true
docker compose exec -T namenode hdfs dfs -mkdir -p /user/hive/warehouse || true
docker compose exec -T namenode hdfs dfs -chmod -R 777 /data /user/hive || true
echo "HDFS bootstrap completed."

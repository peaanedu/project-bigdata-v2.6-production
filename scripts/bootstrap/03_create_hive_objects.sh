#!/usr/bin/env bash
set -euo pipefail

for i in {1..60}; do
  if docker compose exec -T hive-server beeline -u jdbc:hive2://hive-server:10000/default -n hive -e "SHOW DATABASES;" >/dev/null 2>&1; then
    break
  fi
  echo "Waiting for HiveServer2... ($i/60)"
  sleep 5
done

for f in ./sql/hive/*.sql; do
  echo "Applying $f"
  docker compose exec -T hive-server beeline -u jdbc:hive2://hive-server:10000/default -n hive -f "/opt/bootstrap/sql/hive/$(basename "$f")"
done

#!/usr/bin/env bash
set -euo pipefail

for i in {1..60}; do
  if docker compose exec -T trino trino --execute "SHOW CATALOGS" >/dev/null 2>&1; then
    break
  fi
  echo "Waiting for Trino... ($i/60)"
  sleep 5
done

for f in ./sql/trino/*.sql; do
  echo "Applying $f"
  docker compose exec -T trino trino --file "/opt/bootstrap/sql/trino/$(basename "$f")"
done

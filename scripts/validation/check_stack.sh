#!/usr/bin/env bash
set -euo pipefail

docker compose ps
echo
echo "Checking HDFS..."
docker compose exec -T namenode hdfs dfs -ls /
echo
echo "Checking Hive..."
docker compose exec -T hive-server beeline -u jdbc:hive2://hive-server:10000/default -n hive -e "SHOW DATABASES;"
docker compose exec -T hive-server beeline -u jdbc:hive2://hive-server:10000/default -n hive -e "SHOW TABLES IN lab;"
echo
echo "Checking Trino..."
docker compose exec -T trino trino --execute "SHOW SCHEMAS FROM hive;"
docker compose exec -T trino trino --execute "SHOW TABLES FROM hive.powerbi;"

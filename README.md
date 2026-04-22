# Project Big Data v2.6 Enterprise

A production-style single-host lab for Hadoop, Hive, Trino, Spark, Jupyter, PostgreSQL, and Power BI.

## What changed in this enterprise build

- fixed NameNode volume-permission startup issue
- added explicit Hive metastore schema initialization
- added Hive metastore and HiveServer2 readiness checks
- corrected bootstrap scripts to use the working container paths and service endpoints
- added `hive-site.xml` so HiveServer2 and Trino consistently target the same metastore
- kept Trino on port `8081` for Power BI ODBC access

## Stack

- Hadoop `apache/hadoop:3.4.2`
- Hive `apache/hive:4.1.0`
- Trino `trinodb/trino:472`
- Spark `apache/spark:3.5.1-python3`
- PostgreSQL `postgres:15`
- Jupyter `quay.io/jupyter/pyspark-notebook:x86_64-python-3.11.6`

## Repository layout

```text
project-bigdata-v2.6-enterprise/
├── docker-compose.yml
├── .env.example
├── datasets/raw/sales_orders.csv
├── hadoop/conf/
├── hive/conf/hive-site.xml
├── trino/catalog/hive.properties
├── scripts/
│   ├── bootstrap/
│   ├── hadoop/
│   ├── hive/
│   ├── ops/
│   └── validation/
├── sql/hive/
├── sql/trino/
├── powerbi/project-bigdata-trino.pbids
└── jupyter/notebooks/
```

## Startup

```bash
cp .env.example .env
chmod +x scripts/bootstrap/*.sh scripts/validation/*.sh scripts/ops/*.sh scripts/hadoop/*.sh scripts/hive/*.sh

docker compose down -v
docker volume prune -f

docker compose pull
docker compose up -d
```

## Bootstrap

```bash
./scripts/bootstrap/01_init_hdfs.sh
./scripts/bootstrap/02_load_demo_data.sh
./scripts/bootstrap/03_create_hive_objects.sh
./scripts/bootstrap/04_create_powerbi_views.sh
./scripts/validation/check_stack.sh
```

## Access URLs

- NameNode: `http://localhost:9870`
- YARN RM: `http://localhost:8088`
- Spark Master: `http://localhost:8080`
- Trino: `http://localhost:8081`
- Jupyter: `http://localhost:8888`
- HiveServer2: `localhost:10000`

## Power BI

Use the included PBIDS file with a Trino ODBC DSN.

Suggested DSN:
- Host: your Ubuntu server IP
- Port: `8081`
- Catalog: `hive`
- Schema: `powerbi`

Start with Import mode.

## Troubleshooting

### Check service state

```bash
docker compose ps
```

### Check logs

```bash
docker compose logs --tail=100 namenode
docker compose logs --tail=100 hive-metastore
docker compose logs --tail=100 hive-server
docker compose logs --tail=100 trino
```

### Verify manually

```bash
docker compose exec namenode hdfs dfs -ls /
docker compose exec hive-server beeline -u jdbc:hive2://hive-server:10000/default -n hive -e "SHOW DATABASES;"
docker compose exec trino trino --execute "SHOW SCHEMAS FROM hive;"
```

## Notes

The common SLF4J and Log4j warnings in Hive do not usually block the lab. The earlier failures in your run were caused by NameNode volume permissions, bootstrap scripts using the wrong Hive endpoint, and Trino starting before the Hive metastore was truly ready.

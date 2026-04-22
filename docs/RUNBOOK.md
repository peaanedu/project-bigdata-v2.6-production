# Runbook

## Start
cp .env.example .env
docker compose pull
docker compose up -d
./scripts/bootstrap/01_init_hdfs.sh
./scripts/bootstrap/02_load_demo_data.sh
./scripts/bootstrap/03_create_hive_objects.sh
./scripts/bootstrap/04_create_powerbi_views.sh
./scripts/validation/check_stack.sh

## Reset
docker compose down -v

#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
POSTGRES_DB="${POSTGRES_DB:-support_lab}"
POSTGRES_USER="${POSTGRES_USER:-support_lab}"
POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-support_lab_dev_only}"

compose() {
  docker compose --project-directory "${PROJECT_ROOT}" "$@"
}

psql_exec() {
  compose exec -T \
    -e "PGPASSWORD=${POSTGRES_PASSWORD}" \
    db \
    psql \
    --username "${POSTGRES_USER}" \
    --dbname "${POSTGRES_DB}" \
    --set ON_ERROR_STOP=1 \
    --no-psqlrc \
    "$@"
}

apply_sql_file() {
  local file="$1"
  psql_exec < "${PROJECT_ROOT}/${file}"
}

wait_for_database() {
  local attempts=40

  for ((attempt = 1; attempt <= attempts; attempt += 1)); do
    if compose exec -T db pg_isready \
      --username "${POSTGRES_USER}" \
      --dbname "${POSTGRES_DB}" >/dev/null 2>&1; then
      return 0
    fi
    sleep 2
  done

  compose logs db
  echo "PostgreSQL did not become ready." >&2
  return 1
}

reset_public_schema() {
  psql_exec <<'SQL'
DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO CURRENT_USER;
GRANT USAGE ON SCHEMA public TO public;
SQL
}

load_base_database() {
  reset_public_schema
  apply_sql_file "migrations/001_schema.sql"
  apply_sql_file "migrations/002_functions_views.sql"
  apply_sql_file "seed/001_deterministic_seed.sql"
}

load_optimization_indexes() {
  apply_sql_file "migrations/003_optimization_indexes.sql"
  psql_exec --command "ANALYZE;"
}

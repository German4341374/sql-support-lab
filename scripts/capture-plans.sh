#!/usr/bin/env bash

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

RESULTS_DIRECTORY="${PROJECT_ROOT}/optimization/results"

cleanup() {
  compose down --volumes --remove-orphans
}

trap cleanup EXIT

compose down --volumes --remove-orphans
compose up --detach db
wait_for_database
load_base_database

mkdir -p "${RESULTS_DIRECTORY}"
rm -f "${RESULTS_DIRECTORY}"/*.txt

for scenario in "${PROJECT_ROOT}"/optimization/scenarios/*.sql; do
  scenario_name="$(basename "${scenario}" .sql)"
  psql_exec < "${scenario}" > "${RESULTS_DIRECTORY}/${scenario_name}_before.txt"
done

load_optimization_indexes

for scenario in "${PROJECT_ROOT}"/optimization/scenarios/*.sql; do
  scenario_name="$(basename "${scenario}" .sql)"
  psql_exec < "${scenario}" > "${RESULTS_DIRECTORY}/${scenario_name}_after.txt"
done

apply_sql_file "tests/smoke.sql"
apply_sql_file "tests/query_contracts.sql"

for result in "${RESULTS_DIRECTORY}"/*.txt; do
  if ! grep -Eq "(Execution Time|Planning Time)" "${result}"; then
    echo "Expected EXPLAIN ANALYZE output in ${result}." >&2
    exit 1
  fi
done

#!/usr/bin/env bash

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

cleanup() {
  compose down --volumes --remove-orphans
}

trap cleanup EXIT

compose down --volumes --remove-orphans
compose up --detach db
wait_for_database
load_base_database
load_optimization_indexes
apply_sql_file "tests/smoke.sql"
apply_sql_file "tests/query_contracts.sql"

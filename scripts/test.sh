#!/usr/bin/env bash

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

wait_for_database
apply_sql_file "tests/smoke.sql"
apply_sql_file "tests/query_contracts.sql"

#!/usr/bin/env bash

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

wait_for_database
load_base_database
load_optimization_indexes

psql_exec --tuples-only --no-align <<'SQL'
SELECT 'departments=' || count(*) FROM departments;
SELECT 'users=' || count(*) FROM users;
SELECT 'devices=' || count(*) FROM devices;
SELECT 'technicians=' || count(*) FROM technicians;
SELECT 'incidents=' || count(*) FROM incidents;
SELECT 'comments=' || count(*) FROM incident_comments;
SELECT 'installations=' || count(*) FROM software_installations;
SQL

#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

query_count="$(
  find "${PROJECT_ROOT}/queries/basic" "${PROJECT_ROOT}/queries/advanced" \
    -maxdepth 1 \
    -type f \
    -name '*.sql' \
    | wc -l \
    | tr -d ' '
)"

if [[ "${query_count}" -lt 30 ]]; then
  echo "Expected at least 30 query scenarios, found ${query_count}." >&2
  exit 1
fi

if grep -RInE 'random\(\)|gen_random|uuid_generate' \
  "${PROJECT_ROOT}/seed" >/dev/null; then
  echo "Seed must remain deterministic." >&2
  exit 1
fi

if grep -RIl $'\r' \
  "${PROJECT_ROOT}/migrations" \
  "${PROJECT_ROOT}/seed" \
  "${PROJECT_ROOT}/queries" \
  "${PROJECT_ROOT}/optimization" \
  "${PROJECT_ROOT}/tests" >/dev/null; then
  echo "SQL and shell files must use LF line endings." >&2
  exit 1
fi

echo "Layout check passed with ${query_count} SQL scenarios."

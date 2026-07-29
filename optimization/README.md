# Query Plan Optimization

Five repeatable scenarios compare PostgreSQL plans before and after
`migrations/003_optimization_indexes.sql`. The capture script rebuilds the same
20,000-incident dataset, runs `EXPLAIN (ANALYZE, BUFFERS, WAL, SETTINGS)`,
creates the indexes, runs `ANALYZE`, and executes the same statements again.

Run:

```bash
bash scripts/capture-plans.sh
```

Actual results are stored as `optimization/results/<scenario>_before.txt` and
`optimization/results/<scenario>_after.txt`.

## 1. Active Critical queue

Before optimization, PostgreSQL must filter the incident relation and sort the
matching rows. `idx_incidents_active_critical` contains only active Critical
rows in the requested order and includes the selected columns. The expected
change is from a sequential scan plus sort to an index-only or index scan with
little or no explicit sorting.

## 2. Active SLA queue

The support queue filters only active incidents, orders by `sla_deadline`, and
returns the first 100. `idx_incidents_active_sla` is a partial covering index
whose leading key matches the order. This should reduce visited buffers and
allow early termination after the limit.

## 3. Active technician workload

Resolved assignments make up a large share of assignment history but are not
needed for the current workload report. `idx_assignments_active_technician`
indexes only rows where `unassigned_at IS NULL` and includes the join keys. The
optimized plan should read fewer assignment pages and may use an index-only
scan.

## 4. Device problem history

The original indexes do not jointly support a single device, a time range, and
category grouping. `idx_incidents_device_category_created` places `device_id`
first and retains category/time locality, reducing heap pages scanned for a
device-specific investigation.

## 5. Full-text search

Without a GIN index, PostgreSQL evaluates the text-search predicate for every
incident. `idx_incidents_search_document` supports the `@@` operator and should
replace the sequential scan with a bitmap index/heap plan over only matching
documents.

## Reading the evidence

Compare these plan fields rather than execution time alone:

- scan type and index name;
- actual rows examined versus returned;
- rows removed by filter;
- shared buffer hits and reads;
- explicit sort nodes;
- planning and execution time.

Execution time varies by host and cache state. The committed plans are evidence
from the pinned PostgreSQL container in CI, not a universal benchmark.

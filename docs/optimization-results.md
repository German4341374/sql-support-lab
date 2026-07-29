# Measured Optimization Results

The raw before/after plans in `optimization/results/` are captured from the
pinned PostgreSQL 18.4 container against the deterministic 20,000-incident seed.

| Scenario | Before | After | Intended change |
| --- | --- | --- | --- |
| Active Critical | `01_active_critical_before.txt` | `01_active_critical_after.txt` | Filter/sort becomes an ordered partial index path |
| Active SLA queue | `02_active_sla_queue_before.txt` | `02_active_sla_queue_after.txt` | Deadline order uses a partial covering index |
| Technician workload | `03_active_technician_workload_before.txt` | `03_active_technician_workload_after.txt` | Active technician/time index replaces filtering and sorting |
| Device history | `04_device_problem_history_before.txt` | `04_device_problem_history_after.txt` | Category/time/device path narrows recurring-problem analysis |
| Full-text search | `05_full_text_search_before.txt` | `05_full_text_search_after.txt` | Sequential text evaluation becomes a GIN-backed bitmap path |

Execution time is intentionally not hard-coded in this summary because it is
host- and cache-dependent. The committed plans preserve scan nodes, actual row
counts, filter losses, buffers, planning time, and execution time.

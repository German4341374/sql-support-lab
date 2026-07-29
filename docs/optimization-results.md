# Measured Optimization Results

The raw before/after plans in `optimization/results/` were captured from the
pinned PostgreSQL 18.4 container against the deterministic 20,000-incident seed.
All five optimized plans use the intended specialized index.

| Scenario | Before plan | After plan | Execution time | Observed change |
| --- | --- | --- | ---: | --- |
| Active Critical | [`before`](../optimization/results/01_active_critical_before.txt) | [`after`](../optimization/results/01_active_critical_after.txt) | 2.331 → 0.487 ms | General created-time scan filtered 3,519 rows; partial covering index returned the first 100 |
| Active SLA queue | [`before`](../optimization/results/02_active_sla_queue_before.txt) | [`after`](../optimization/results/02_active_sla_queue_after.txt) | 6.762 → 0.551 ms | Sequential scan and top-N sort became a deadline-ordered partial index scan |
| Technician queue | [`before`](../optimization/results/03_active_technician_workload_before.txt) | [`after`](../optimization/results/03_active_technician_workload_after.txt) | 2.388 → 0.594 ms | 22,829 filtered assignment rows became a 28-row bitmap index path |
| Recurring device problems | [`before`](../optimization/results/04_device_problem_history_before.txt) | [`after`](../optimization/results/04_device_problem_history_after.txt) | 5.232 → 2.291 ms | Relation-wide category filtering became a composite bitmap index path |
| Full-text search | [`before`](../optimization/results/05_full_text_search_before.txt) | [`after`](../optimization/results/05_full_text_search_after.txt) | 8.108 → 3.472 ms | Sequential text evaluation became a GIN-backed bitmap scan |

These timings describe one CI run and are not portable benchmarks. The more
important evidence is the scan-node change, filtered rows, explicit sort
removal, and buffer pattern preserved in each committed plan.

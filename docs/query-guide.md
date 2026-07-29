# Query Guide

## Recommended progression

Start with queries 01–15 to practice joins, filters, grouping, time arithmetic,
filtered aggregates, and anti-joins. Continue with 16–20 for window functions,
recursive CTEs, ranking, ordered-set aggregates, and materialized views.

Queries 21–23 demonstrate write behavior. They end with `ROLLBACK`, so the
deterministic lab remains unchanged. Queries 24–35 cover index-aware design,
full-text search, cohorts, LATERAL joins, JSONB reporting, and generated time
series.

## Useful exercises

- change the fixed reporting cutoff while keeping it explicit;
- replace a correlated anti-join with a left join and compare plans;
- extend the recursive department query with user counts;
- partition percentile results by service as well as priority;
- compare `row_number`, `rank`, and `dense_rank`;
- refresh the materialized view after inserting a new month;
- remove one specialized index and predict the new plan before running it.

## Safe execution

Read a query before executing it. Operational scenarios are read-only. The three
write demonstrations use transactions and rollback, but they still acquire
locks while running.

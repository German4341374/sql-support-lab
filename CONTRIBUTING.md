# Contributing

## Workflow

1. Create a focused branch from `main`.
2. Keep SQL, comments, documentation, and commits in English.
3. Add deterministic fixtures rather than real support data.
4. Run `bash scripts/check-layout.sh`.
5. Run `bash scripts/smoke-test.sh`.
6. Re-capture plans when a query or index changes.
7. Use a Conventional Commit such as `perf: add active SLA covering index`.

## SQL guidelines

- name constraints and indexes;
- use explicit joins and stable reporting timestamps in examples;
- avoid `SELECT *` in portfolio queries;
- explain index write/storage trade-offs;
- never force a planner option merely to obtain a preferred plan;
- make write examples rollback-safe.

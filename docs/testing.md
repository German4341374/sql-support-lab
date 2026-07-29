# Testing Workflow

## Layout check

`scripts/check-layout.sh` verifies that at least 30 query scenarios exist, the
seed contains no random generator functions, and SQL files use LF line endings.

## Database smoke test

`scripts/smoke-test.sh`:

1. removes only the current Compose project and named volume;
2. starts the pinned PostgreSQL image;
3. waits for `pg_isready`;
4. rebuilds the public schema;
5. applies functions, views, seed, and optimized indexes;
6. verifies deterministic counts and behavioral contracts;
7. removes the disposable environment.

The audit trigger is tested inside a transaction that is rolled back.

## Plan capture

`scripts/capture-plans.sh` loads the schema without specialized indexes,
captures five plans, applies indexes, runs `ANALYZE`, and captures the same five
plans again. Each result must contain PostgreSQL planning or execution timing.

## Continuous integration

GitHub Actions uses read-only repository permission, concurrency cancellation,
the pinned container, timeouts, cleanup steps, and a short-lived plan artifact.
It never connects to an external database.

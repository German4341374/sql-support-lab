\set ON_ERROR_STOP on

EXPLAIN (ANALYZE, BUFFERS, WAL, SETTINGS, FORMAT TEXT)
SELECT
  id,
  title,
  sla_deadline,
  created_at
FROM incidents
WHERE status IN ('OPEN', 'IN_PROGRESS')
  AND priority = 'CRITICAL'
ORDER BY created_at DESC
LIMIT 100;

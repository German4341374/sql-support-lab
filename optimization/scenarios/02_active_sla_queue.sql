\set ON_ERROR_STOP on

EXPLAIN (ANALYZE, BUFFERS, WAL, SETTINGS, FORMAT TEXT)
SELECT
  id,
  priority,
  requester_user_id,
  device_id,
  sla_deadline
FROM incidents
WHERE status IN ('OPEN', 'IN_PROGRESS')
  AND sla_deadline < timestamptz '2026-01-01 00:00:00+00'
ORDER BY sla_deadline
LIMIT 100;

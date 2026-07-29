\set ON_ERROR_STOP on

EXPLAIN (ANALYZE, BUFFERS, WAL, SETTINGS, FORMAT TEXT)
SELECT
  category,
  count(*) AS incident_count,
  min(created_at) AS first_seen_at,
  max(created_at) AS last_seen_at
FROM incidents
WHERE device_id = 42
  AND created_at >= timestamptz '2025-01-01 00:00:00+00'
GROUP BY category
HAVING count(*) > 1
ORDER BY incident_count DESC;

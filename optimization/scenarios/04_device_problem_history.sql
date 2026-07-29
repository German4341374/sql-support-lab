\set ON_ERROR_STOP on

EXPLAIN (ANALYZE, BUFFERS, WAL, SETTINGS, FORMAT TEXT)
SELECT
  device_id,
  count(*) AS incident_count,
  min(created_at) AS first_seen_at,
  max(created_at) AS last_seen_at
FROM incidents
WHERE category = 'Database'
  AND device_id IS NOT NULL
  AND created_at >= timestamptz '2025-01-01 00:00:00+00'
GROUP BY device_id
HAVING count(*) >= 2
ORDER BY incident_count DESC, device_id
LIMIT 100;

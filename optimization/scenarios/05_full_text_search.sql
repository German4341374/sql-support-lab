\set ON_ERROR_STOP on

EXPLAIN (ANALYZE, BUFFERS, WAL, SETTINGS, FORMAT TEXT)
SELECT
  id,
  title,
  priority,
  status
FROM incidents
WHERE search_document @@ websearch_to_tsquery('english', '"database timeout"')
ORDER BY created_at DESC
LIMIT 50;

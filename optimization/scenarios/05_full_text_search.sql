\set ON_ERROR_STOP on

EXPLAIN (ANALYZE, BUFFERS, WAL, SETTINGS, FORMAT TEXT)
SELECT
  count(*) AS matching_incidents
FROM incidents
WHERE search_document @@ websearch_to_tsquery('english', '"database timeout"');

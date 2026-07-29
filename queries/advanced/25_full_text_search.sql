-- Scenario 25: Full-text search across incident title, description, and category.
SELECT
  id,
  title,
  priority,
  status,
  ts_rank(
    search_document,
    websearch_to_tsquery('english', '"database timeout"')
  ) AS relevance
FROM incidents
WHERE search_document @@ websearch_to_tsquery('english', '"database timeout"')
ORDER BY relevance DESC, created_at DESC
LIMIT 50;

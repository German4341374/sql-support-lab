-- Scenario 24: Query shaped for the active-Critical partial index.
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

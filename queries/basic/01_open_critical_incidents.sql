-- Scenario 01: Open Critical incidents ordered by the oldest SLA deadline.
SELECT
  id,
  title,
  status,
  service_name,
  sla_deadline,
  created_at
FROM incidents
WHERE priority = 'CRITICAL'
  AND status IN ('OPEN', 'IN_PROGRESS')
ORDER BY sla_deadline, created_at
LIMIT 100;

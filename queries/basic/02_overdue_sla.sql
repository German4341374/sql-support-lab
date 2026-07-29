-- Scenario 02: Active incidents overdue at a fixed reproducible reporting time.
SELECT
  id,
  priority,
  status,
  sla_deadline,
  timestamptz '2026-01-01 00:00:00+00' - sla_deadline AS overdue_by
FROM incidents
WHERE status IN ('OPEN', 'IN_PROGRESS')
  AND sla_deadline < timestamptz '2026-01-01 00:00:00+00'
ORDER BY sla_deadline
LIMIT 100;

-- Scenario 12: Incident count matrix by status and priority.
SELECT
  status,
  count(*) FILTER (WHERE priority = 'CRITICAL') AS critical,
  count(*) FILTER (WHERE priority = 'HIGH') AS high,
  count(*) FILTER (WHERE priority = 'MEDIUM') AS medium,
  count(*) FILTER (WHERE priority = 'LOW') AS low,
  count(*) AS total
FROM incidents
GROUP BY status
ORDER BY status;

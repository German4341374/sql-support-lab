-- Scenario 03: Average resolution time and sample size by priority.
SELECT
  priority,
  count(*) AS resolved_incidents,
  round(avg(extract(epoch FROM (resolved_at - created_at)) / 3600.0), 2)
    AS average_resolution_hours
FROM incidents
WHERE resolved_at IS NOT NULL
GROUP BY priority
ORDER BY array_position(
  ARRAY['CRITICAL', 'HIGH', 'MEDIUM', 'LOW']::incident_priority[],
  priority
);

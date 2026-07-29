-- Scenario 14: Resolution SLA compliance percentage by priority.
SELECT
  priority,
  count(*) AS resolved_incidents,
  count(*) FILTER (WHERE resolved_at <= sla_deadline) AS within_sla,
  round(
    100.0 * count(*) FILTER (WHERE resolved_at <= sla_deadline)
      / NULLIF(count(*), 0),
    2
  ) AS compliance_percent
FROM incidents
WHERE resolved_at IS NOT NULL
GROUP BY priority
ORDER BY priority;

-- Scenario 09: Monthly incident volume with resolved and breached counts.
SELECT
  date_trunc('month', created_at)::date AS month,
  count(*) AS created_incidents,
  count(*) FILTER (WHERE resolved_at IS NOT NULL) AS resolved_incidents,
  count(*) FILTER (
    WHERE resolved_at IS NOT NULL AND resolved_at > sla_deadline
  ) AS sla_breaches
FROM incidents
GROUP BY date_trunc('month', created_at)::date
ORDER BY month;

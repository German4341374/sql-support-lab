-- Scenario 20: Query the pre-aggregated monthly materialized view.
SELECT
  month,
  priority,
  incident_count,
  resolved_count,
  average_resolution_hours,
  round(
    100.0 * resolved_within_sla / NULLIF(resolved_count, 0),
    2
  ) AS resolution_sla_percent
FROM mv_monthly_incident_metrics
ORDER BY month DESC, priority
LIMIT 24;

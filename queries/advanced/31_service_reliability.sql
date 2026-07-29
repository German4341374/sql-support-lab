-- Scenario 31: Service-level volume, Critical share, and SLA breach counts.
SELECT
  service_name,
  count(*) AS total_incidents,
  count(*) FILTER (WHERE priority = 'CRITICAL') AS critical_incidents,
  count(*) FILTER (
    WHERE resolved_at IS NOT NULL AND resolved_at > sla_deadline
  ) AS resolved_sla_breaches,
  round(
    100.0 * count(*) FILTER (WHERE priority = 'CRITICAL')
      / NULLIF(count(*), 0),
    2
  ) AS critical_percent
FROM incidents
GROUP BY service_name
ORDER BY resolved_sla_breaches DESC, service_name;

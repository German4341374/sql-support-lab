-- Scenario 28: SLA breach rate by requester department.
SELECT
  department.name,
  count(*) FILTER (WHERE incident.resolved_at IS NOT NULL) AS resolved_incidents,
  count(*) FILTER (
    WHERE incident.resolved_at IS NOT NULL
      AND incident.resolved_at > incident.sla_deadline
  ) AS breached_incidents,
  round(
    100.0 * count(*) FILTER (
      WHERE incident.resolved_at IS NOT NULL
        AND incident.resolved_at > incident.sla_deadline
    ) / NULLIF(count(*) FILTER (WHERE incident.resolved_at IS NOT NULL), 0),
    2
  ) AS breach_percent
FROM departments AS department
JOIN users AS requester ON requester.department_id = department.id
JOIN incidents AS incident ON incident.requester_user_id = requester.id
GROUP BY department.id, department.name
ORDER BY breach_percent DESC NULLS LAST, department.name;

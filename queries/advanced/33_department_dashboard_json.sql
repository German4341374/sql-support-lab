-- Scenario 33: Build a compact department dashboard document with JSONB.
SELECT jsonb_pretty(
  jsonb_agg(
    jsonb_build_object(
      'department', department_name,
      'users', user_count,
      'incidents', incident_count,
      'activeIncidents', active_incident_count
    )
    ORDER BY department_name
  )
) AS department_dashboard
FROM (
  SELECT
    department.name AS department_name,
    count(DISTINCT requester.id) AS user_count,
    count(incident.id) AS incident_count,
    count(incident.id) FILTER (
      WHERE incident.status IN ('OPEN', 'IN_PROGRESS')
    ) AS active_incident_count
  FROM departments AS department
  LEFT JOIN users AS requester ON requester.department_id = department.id
  LEFT JOIN incidents AS incident ON incident.requester_user_id = requester.id
  GROUP BY department.id, department.name
) AS department_metrics;

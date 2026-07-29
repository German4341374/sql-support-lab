-- Scenario 06: Users with the most incidents and their active incident count.
SELECT
  requester.id,
  requester.full_name,
  department.name AS department,
  count(*) AS total_incidents,
  count(*) FILTER (WHERE incident.status IN ('OPEN', 'IN_PROGRESS')) AS active_incidents
FROM users AS requester
JOIN departments AS department ON department.id = requester.department_id
JOIN incidents AS incident ON incident.requester_user_id = requester.id
GROUP BY requester.id, requester.full_name, department.name
ORDER BY total_incidents DESC, requester.id
LIMIT 25;

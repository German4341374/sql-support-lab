-- Scenario 15: Active incidents missing an active primary technician assignment.
SELECT
  incident.id,
  incident.title,
  incident.priority,
  incident.created_at
FROM incidents AS incident
WHERE incident.status IN ('OPEN', 'IN_PROGRESS')
  AND NOT EXISTS (
    SELECT 1
    FROM incident_assignments AS assignment
    WHERE assignment.incident_id = incident.id
      AND assignment.role = 'PRIMARY'
      AND assignment.unassigned_at IS NULL
  )
ORDER BY incident.priority DESC, incident.created_at
LIMIT 100;

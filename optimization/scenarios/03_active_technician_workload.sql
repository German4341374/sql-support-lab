\set ON_ERROR_STOP on

EXPLAIN (ANALYZE, BUFFERS, WAL, SETTINGS, FORMAT TEXT)
SELECT
  assignment.incident_id,
  assignment.role,
  assignment.assigned_at,
  incident.priority,
  incident.title
FROM incident_assignments AS assignment
JOIN incidents AS incident ON incident.id = assignment.incident_id
WHERE assignment.unassigned_at IS NULL
  AND assignment.technician_id = 42
ORDER BY assignment.assigned_at DESC
LIMIT 100;

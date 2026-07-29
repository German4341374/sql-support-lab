\set ON_ERROR_STOP on

EXPLAIN (ANALYZE, BUFFERS, WAL, SETTINGS, FORMAT TEXT)
SELECT
  technician.id,
  technician.full_name,
  count(*) AS active_assignments
FROM technicians AS technician
JOIN incident_assignments AS assignment
  ON assignment.technician_id = technician.id
WHERE assignment.unassigned_at IS NULL
GROUP BY technician.id, technician.full_name
ORDER BY active_assignments DESC, technician.id
LIMIT 20;

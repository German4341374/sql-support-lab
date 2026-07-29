-- Scenario 04: Technicians with the largest current assignment workload.
SELECT
  technician.id,
  technician.full_name,
  technician.skill_level,
  count(*) AS active_assignments
FROM technicians AS technician
JOIN incident_assignments AS assignment
  ON assignment.technician_id = technician.id
  AND assignment.unassigned_at IS NULL
GROUP BY technician.id, technician.full_name, technician.skill_level
ORDER BY active_assignments DESC, technician.id
LIMIT 20;

-- Scenario 18: Rank technicians by resolved assignments within each skill level.
WITH technician_results AS (
  SELECT
    technician.id,
    technician.full_name,
    technician.skill_level,
    count(*) FILTER (WHERE incident.resolved_at IS NOT NULL) AS resolved_count
  FROM technicians AS technician
  LEFT JOIN incident_assignments AS assignment
    ON assignment.technician_id = technician.id
  LEFT JOIN incidents AS incident ON incident.id = assignment.incident_id
  GROUP BY technician.id, technician.full_name, technician.skill_level
)
SELECT
  *,
  dense_rank() OVER (
    PARTITION BY skill_level
    ORDER BY resolved_count DESC
  ) AS skill_level_rank
FROM technician_results
ORDER BY skill_level DESC, skill_level_rank, id;

-- Scenario 21: Atomic assignment and status transition, rolled back for safe practice.
BEGIN;

SELECT id, status
FROM incidents
WHERE id = 19999
FOR UPDATE;

UPDATE incident_assignments
SET unassigned_at = timestamptz '2026-02-01 09:00:00+00'
WHERE incident_id = 19999
  AND role = 'PRIMARY'
  AND unassigned_at IS NULL;

INSERT INTO incident_assignments (
  incident_id,
  technician_id,
  role,
  assigned_at
)
VALUES (
  19999,
  42,
  'PRIMARY',
  timestamptz '2026-02-01 09:00:00+00'
);

UPDATE incidents
SET status = 'IN_PROGRESS'
WHERE id = 19999;

ROLLBACK;

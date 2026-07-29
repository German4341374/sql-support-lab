-- Scenario 23: Demonstrate the audit trigger without keeping test changes.
BEGIN;

UPDATE incidents
SET title = title || ' [audit demonstration]'
WHERE id = 42;

SELECT
  incident_id,
  action,
  old_row ->> 'title' AS old_title,
  new_row ->> 'title' AS new_title,
  changed_at
FROM incident_audit_log
WHERE incident_id = 42
ORDER BY changed_at DESC
LIMIT 1;

ROLLBACK;

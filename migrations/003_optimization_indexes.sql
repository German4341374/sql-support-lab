BEGIN;

CREATE INDEX IF NOT EXISTS idx_incidents_active_critical
  ON incidents (created_at DESC)
  INCLUDE (id, title, sla_deadline)
  WHERE status IN ('OPEN', 'IN_PROGRESS') AND priority = 'CRITICAL';

CREATE INDEX IF NOT EXISTS idx_incidents_active_sla
  ON incidents (sla_deadline)
  INCLUDE (priority, requester_user_id, device_id)
  WHERE status IN ('OPEN', 'IN_PROGRESS');

CREATE INDEX IF NOT EXISTS idx_assignments_active_technician
  ON incident_assignments (technician_id, assigned_at DESC)
  INCLUDE (incident_id)
  WHERE unassigned_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_incidents_category_created_device
  ON incidents (category, created_at DESC, device_id)
  WHERE device_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_incidents_search_document
  ON incidents USING gin (search_document);

COMMIT;

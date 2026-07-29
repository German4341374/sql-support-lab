BEGIN;

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at := clock_timestamp();
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION audit_incident_change()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO incident_audit_log (incident_id, action, old_row, new_row)
    VALUES (
      OLD.id,
      'UPDATE',
      to_jsonb(OLD) - 'search_document',
      to_jsonb(NEW) - 'search_document'
    );
    RETURN NEW;
  END IF;

  INSERT INTO incident_audit_log (incident_id, action, old_row, new_row)
  VALUES (
    OLD.id,
    'DELETE',
    to_jsonb(OLD) - 'search_document',
    NULL
  );
  RETURN OLD;
END;
$$;

CREATE TRIGGER departments_set_updated_at
BEFORE UPDATE ON departments
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER users_set_updated_at
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER devices_set_updated_at
BEFORE UPDATE ON devices
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER technicians_set_updated_at
BEFORE UPDATE ON technicians
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER sla_policies_set_updated_at
BEFORE UPDATE ON sla_policies
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER incidents_set_updated_at
BEFORE UPDATE ON incidents
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER incident_comments_set_updated_at
BEFORE UPDATE ON incident_comments
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER software_set_updated_at
BEFORE UPDATE ON software
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER software_installations_set_updated_at
BEFORE UPDATE ON software_installations
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER incident_assignments_set_updated_at
BEFORE UPDATE ON incident_assignments
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER incidents_audit_update
AFTER UPDATE ON incidents
FOR EACH ROW EXECUTE FUNCTION audit_incident_change();

CREATE TRIGGER incidents_audit_delete
AFTER DELETE ON incidents
FOR EACH ROW EXECUTE FUNCTION audit_incident_change();

CREATE MATERIALIZED VIEW mv_monthly_incident_metrics AS
SELECT
  date_trunc('month', created_at)::date AS month,
  priority,
  count(*) AS incident_count,
  count(*) FILTER (WHERE status IN ('RESOLVED', 'CLOSED')) AS resolved_count,
  round(
    avg(extract(epoch FROM (resolved_at - created_at)) / 3600.0)
      FILTER (WHERE resolved_at IS NOT NULL),
    2
  ) AS average_resolution_hours,
  count(*) FILTER (
    WHERE resolved_at IS NOT NULL AND resolved_at <= sla_deadline
  ) AS resolved_within_sla
FROM incidents
GROUP BY date_trunc('month', created_at)::date, priority
WITH NO DATA;

CREATE UNIQUE INDEX uq_mv_monthly_incident_metrics
  ON mv_monthly_incident_metrics (month, priority);

CREATE OR REPLACE VIEW active_incident_details AS
SELECT
  i.id,
  i.title,
  i.priority,
  i.status,
  i.sla_deadline,
  i.created_at,
  u.full_name AS requester,
  d.asset_tag,
  t.full_name AS primary_technician
FROM incidents AS i
JOIN users AS u ON u.id = i.requester_user_id
LEFT JOIN devices AS d ON d.id = i.device_id
LEFT JOIN incident_assignments AS ia
  ON ia.incident_id = i.id
  AND ia.role = 'PRIMARY'
  AND ia.unassigned_at IS NULL
LEFT JOIN technicians AS t ON t.id = ia.technician_id
WHERE i.status IN ('OPEN', 'IN_PROGRESS');

COMMIT;

\set ON_ERROR_STOP on

DO $$
DECLARE
  actual_count bigint;
BEGIN
  SELECT count(*) INTO actual_count FROM departments;
  IF actual_count <> 20 THEN
    RAISE EXCEPTION 'Expected 20 departments, found %', actual_count;
  END IF;

  SELECT count(*) INTO actual_count FROM users;
  IF actual_count <> 500 THEN
    RAISE EXCEPTION 'Expected 500 users, found %', actual_count;
  END IF;

  SELECT count(*) INTO actual_count FROM devices;
  IF actual_count <> 1000 THEN
    RAISE EXCEPTION 'Expected 1000 devices, found %', actual_count;
  END IF;

  SELECT count(*) INTO actual_count FROM technicians;
  IF actual_count <> 100 THEN
    RAISE EXCEPTION 'Expected 100 technicians, found %', actual_count;
  END IF;

  SELECT count(*) INTO actual_count FROM incidents;
  IF actual_count <> 20000 THEN
    RAISE EXCEPTION 'Expected 20000 incidents, found %', actual_count;
  END IF;

  SELECT count(*) INTO actual_count FROM incident_comments;
  IF actual_count <> 40000 THEN
    RAISE EXCEPTION 'Expected 40000 comments, found %', actual_count;
  END IF;

  SELECT count(*) INTO actual_count FROM software_installations;
  IF actual_count <> 6000 THEN
    RAISE EXCEPTION 'Expected 6000 software installations, found %', actual_count;
  END IF;

  SELECT count(*) INTO actual_count
  FROM incidents
  WHERE priority = 'CRITICAL'
    AND status IN ('OPEN', 'IN_PROGRESS');
  IF actual_count < 100 THEN
    RAISE EXCEPTION 'Expected a useful active Critical incident sample, found %', actual_count;
  END IF;

  SELECT count(*) INTO actual_count
  FROM incidents
  WHERE status IN ('OPEN', 'IN_PROGRESS')
    AND sla_deadline < timestamptz '2026-01-01 00:00:00+00';
  IF actual_count = 0 THEN
    RAISE EXCEPTION 'Expected overdue SLA incidents.';
  END IF;

  SELECT count(*) INTO actual_count FROM mv_monthly_incident_metrics;
  IF actual_count < 40 THEN
    RAISE EXCEPTION 'Expected populated monthly metrics, found % rows', actual_count;
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE schemaname = 'public'
      AND indexname = 'idx_incidents_search_document'
  ) THEN
    RAISE EXCEPTION 'Expected full-text search index.';
  END IF;
END;
$$;

BEGIN;

UPDATE incidents
SET title = title || ' audit-smoke'
WHERE id = 1;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM incident_audit_log
    WHERE incident_id = 1
      AND action = 'UPDATE'
  ) THEN
    RAISE EXCEPTION 'Incident audit trigger did not record the update.';
  END IF;
END;
$$;

ROLLBACK;

SELECT
  'smoke-test-passed' AS result,
  (SELECT count(*) FROM incidents) AS incident_count,
  (SELECT count(*) FROM incident_comments) AS comment_count;

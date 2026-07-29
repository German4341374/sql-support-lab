\set ON_ERROR_STOP on

DO $$
DECLARE
  actual_count bigint;
  numeric_result numeric;
  hierarchy_depth integer;
BEGIN
  SELECT count(*) INTO actual_count
  FROM incidents
  WHERE search_document @@ websearch_to_tsquery('english', '"database timeout"');
  IF actual_count < 1000 THEN
    RAISE EXCEPTION 'Expected a substantial full-text match set, found %', actual_count;
  END IF;

  SELECT count(*) INTO actual_count
  FROM software_installations AS installation
  JOIN software ON software.id = installation.software_id
  WHERE installation.installed_version <> software.latest_version;
  IF actual_count < 1000 THEN
    RAISE EXCEPTION 'Expected outdated software examples, found %', actual_count;
  END IF;

  SELECT avg(extract(epoch FROM (first_response_at - created_at)) / 60.0)
  INTO numeric_result
  FROM incidents
  WHERE first_response_at IS NOT NULL;
  IF numeric_result IS NULL OR numeric_result <= 0 THEN
    RAISE EXCEPTION 'Expected a positive first-response average.';
  END IF;

  SELECT sum(incident_count) INTO actual_count
  FROM mv_monthly_incident_metrics;
  IF actual_count <> 20000 THEN
    RAISE EXCEPTION 'Materialized metrics cover % incidents instead of 20000.', actual_count;
  END IF;

  WITH RECURSIVE department_tree AS (
    SELECT id, parent_department_id, 0 AS depth
    FROM departments
    WHERE parent_department_id IS NULL

    UNION ALL

    SELECT child.id, child.parent_department_id, parent.depth + 1
    FROM departments AS child
    JOIN department_tree AS parent ON parent.id = child.parent_department_id
  )
  SELECT max(depth) INTO hierarchy_depth FROM department_tree;

  IF hierarchy_depth <> 2 THEN
    RAISE EXCEPTION 'Expected department hierarchy depth 2, found %', hierarchy_depth;
  END IF;

  SELECT count(*) INTO actual_count
  FROM (
    SELECT device_id, category
    FROM incidents
    WHERE device_id IS NOT NULL
    GROUP BY device_id, category
    HAVING count(*) >= 5
  ) AS repeated_problems;
  IF actual_count = 0 THEN
    RAISE EXCEPTION 'Expected repeated device problem groups.';
  END IF;
END;
$$;

SELECT
  'query-contracts-passed' AS result,
  (
    SELECT count(*)
    FROM incidents
    WHERE priority = 'CRITICAL'
      AND status IN ('OPEN', 'IN_PROGRESS')
  ) AS active_critical_incidents;

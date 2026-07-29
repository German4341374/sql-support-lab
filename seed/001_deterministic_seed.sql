BEGIN;

SET LOCAL TIME ZONE 'UTC';

INSERT INTO departments (id, parent_department_id, code, name, cost_center, created_at, updated_at)
VALUES
  (1, NULL, 'CORP', 'Corporate Services', 'CC-1000', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (2, 1, 'TECH', 'Technology', 'CC-1100', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (3, 1, 'OPS', 'Operations', 'CC-1200', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (4, 1, 'FIN', 'Finance', 'CC-1300', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (5, 1, 'PEOPLE', 'People Operations', 'CC-1400', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (6, 2, 'SDESK', 'Service Desk', 'CC-1110', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (7, 2, 'PLAT', 'Platform Engineering', 'CC-1120', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (8, 2, 'SEC', 'Information Security', 'CC-1130', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (9, 2, 'APPS', 'Business Applications', 'CC-1140', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (10, 3, 'LOG', 'Logistics', 'CC-1210', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (11, 3, 'FAC', 'Facilities', 'CC-1220', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (12, 3, 'CUSTSUP', 'Customer Support', 'CC-1230', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (13, 4, 'ACC', 'Accounting', 'CC-1310', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (14, 4, 'PROC', 'Procurement', 'CC-1320', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (15, 4, 'RISK', 'Risk Management', 'CC-1330', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (16, 5, 'HROPS', 'Human Resources', 'CC-1410', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (17, 5, 'LND', 'Learning and Development', 'CC-1420', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (18, 1, 'LEGAL', 'Legal', 'CC-1500', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (19, 1, 'SALES', 'Sales', 'CC-1600', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00'),
  (20, 1, 'MKTG', 'Marketing', 'CC-1700', '2024-01-01 00:00:00+00', '2024-01-01 00:00:00+00');

INSERT INTO users (
  id,
  department_id,
  employee_number,
  full_name,
  email,
  status,
  location,
  created_at,
  updated_at
)
SELECT
  series_id,
  ((series_id - 1) % 20) + 1,
  'USR-' || lpad(series_id::text, 5, '0'),
  'Service Desk User ' || lpad(series_id::text, 3, '0'),
  'user' || lpad(series_id::text, 3, '0') || '@example.test',
  CASE
    WHEN series_id % 50 = 0 THEN 'DISABLED'::user_status
    WHEN series_id % 37 = 0 THEN 'ON_LEAVE'::user_status
    ELSE 'ACTIVE'::user_status
  END,
  'Office-' || (((series_id - 1) % 8) + 1),
  timestamptz '2024-01-01 00:00:00+00' + (series_id % 90) * interval '1 day',
  timestamptz '2024-01-01 00:00:00+00' + (series_id % 90) * interval '1 day'
FROM generate_series(1, 500) AS generated(series_id);

INSERT INTO technicians (
  id,
  department_id,
  employee_number,
  full_name,
  email,
  skill_level,
  skills,
  is_active,
  created_at,
  updated_at
)
SELECT
  series_id,
  6 + ((series_id - 1) % 4),
  'TECH-' || lpad(series_id::text, 4, '0'),
  'Support Technician ' || lpad(series_id::text, 3, '0'),
  'technician' || lpad(series_id::text, 3, '0') || '@example.test',
  1 + (series_id % 5),
  ARRAY[
    CASE series_id % 5
      WHEN 0 THEN 'network'
      WHEN 1 THEN 'database'
      WHEN 2 THEN 'endpoint'
      WHEN 3 THEN 'identity'
      ELSE 'applications'
    END,
    'service-desk'
  ],
  series_id % 29 <> 0,
  timestamptz '2024-01-01 00:00:00+00' + (series_id % 60) * interval '1 day',
  timestamptz '2024-01-01 00:00:00+00' + (series_id % 60) * interval '1 day'
FROM generate_series(1, 100) AS generated(series_id);

INSERT INTO devices (
  id,
  assigned_user_id,
  asset_tag,
  serial_number,
  hostname,
  type,
  status,
  manufacturer,
  model,
  operating_system,
  purchase_date,
  warranty_until,
  created_at,
  updated_at
)
SELECT
  series_id,
  CASE
    WHEN series_id % 10 IN (4, 5, 6, 7, 8, 9) THEN ((series_id * 17 - 1) % 500) + 1
    ELSE NULL
  END,
  'AST-' || lpad(series_id::text, 6, '0'),
  'SN-DEMO-' || lpad((series_id * 7919)::text, 9, '0'),
  CASE
    WHEN series_id % 5 = 4 THEN NULL
    ELSE 'host-' || lpad(series_id::text, 4, '0')
  END,
  CASE series_id % 5
    WHEN 0 THEN 'DESKTOP'::device_type
    WHEN 1 THEN 'LAPTOP'::device_type
    WHEN 2 THEN 'TABLET'::device_type
    WHEN 3 THEN 'PHONE'::device_type
    ELSE 'MONITOR'::device_type
  END,
  CASE
    WHEN series_id % 10 = 0 THEN 'RETIRED'::device_status
    WHEN series_id % 10 = 1 THEN 'REPAIR'::device_status
    WHEN series_id % 10 IN (2, 3) THEN 'IN_STOCK'::device_status
    ELSE 'ASSIGNED'::device_status
  END,
  'Vendor-' || ((series_id % 8) + 1),
  'Model-' || ((series_id % 24) + 1),
  CASE series_id % 4
    WHEN 0 THEN 'Ubuntu 24.04 LTS'
    WHEN 1 THEN 'Windows 11 Enterprise'
    WHEN 2 THEN 'Android 15'
    ELSE 'iOS 19'
  END,
  date '2020-01-01' + ((series_id * 13) % 1800),
  date '2020-01-01' + ((series_id * 13) % 1800) + 1095,
  timestamptz '2024-01-01 00:00:00+00',
  timestamptz '2024-01-01 00:00:00+00'
FROM generate_series(1, 1000) AS generated(series_id);

INSERT INTO software (
  id,
  vendor,
  name,
  latest_version,
  support_ends_on,
  created_at,
  updated_at
)
SELECT
  series_id,
  'Software Vendor ' || (((series_id - 1) % 10) + 1),
  'Support Product ' || lpad(series_id::text, 2, '0'),
  format('%s.%s.%s', 1 + (series_id % 5), series_id % 10, series_id % 7),
  (date '2027-01-01' + (series_id % 24) * interval '1 month')::date,
  timestamptz '2024-01-01 00:00:00+00',
  timestamptz '2024-01-01 00:00:00+00'
FROM generate_series(1, 50) AS generated(series_id);

WITH installation_source AS (
  SELECT
    device_id,
    slot,
    ((device_id * 7 + slot * 3) % 50) + 1 AS software_id
  FROM generate_series(1, 1000) AS devices(device_id)
  CROSS JOIN generate_series(1, 6) AS slots(slot)
)
INSERT INTO software_installations (
  device_id,
  software_id,
  installed_version,
  installed_at,
  last_seen_at,
  created_at,
  updated_at
)
SELECT
  source.device_id,
  source.software_id,
  CASE
    WHEN (source.device_id + source.slot) % 4 = 0
      THEN format('%s.%s.%s', 1 + (source.software_id % 5), 0, source.software_id % 7)
    ELSE software.latest_version
  END,
  timestamptz '2024-01-01 00:00:00+00'
    + ((source.device_id + source.slot) % 600) * interval '1 day',
  timestamptz '2026-01-15 00:00:00+00'
    + (source.device_id % 30) * interval '1 day',
  timestamptz '2024-01-01 00:00:00+00',
  timestamptz '2026-02-15 00:00:00+00'
FROM installation_source AS source
JOIN software ON software.id = source.software_id;

WITH incident_source_data AS (
  SELECT
    series_id,
    timestamptz '2024-01-01 00:00:00+00'
      + ((series_id * 13) % 730) * interval '1 day'
      + ((series_id * 47) % 1440) * interval '1 minute' AS created_timestamp,
    CASE
      WHEN series_id % 17 = 0 THEN 'CRITICAL'::incident_priority
      WHEN series_id % 5 = 0 THEN 'HIGH'::incident_priority
      WHEN series_id % 2 = 0 THEN 'MEDIUM'::incident_priority
      ELSE 'LOW'::incident_priority
    END AS generated_priority,
    CASE series_id % 10
      WHEN 0 THEN 'CLOSED'::incident_status
      WHEN 1 THEN 'CLOSED'::incident_status
      WHEN 2 THEN 'CLOSED'::incident_status
      WHEN 3 THEN 'RESOLVED'::incident_status
      WHEN 4 THEN 'RESOLVED'::incident_status
      WHEN 5 THEN 'IN_PROGRESS'::incident_status
      WHEN 6 THEN 'IN_PROGRESS'::incident_status
      WHEN 7 THEN 'IN_PROGRESS'::incident_status
      ELSE 'OPEN'::incident_status
    END AS generated_status
  FROM generate_series(1, 20000) AS generated(series_id)
),
prepared_incidents AS (
  SELECT
    *,
    CASE generated_priority
      WHEN 'CRITICAL' THEN interval '2 hours'
      WHEN 'HIGH' THEN interval '8 hours'
      WHEN 'MEDIUM' THEN interval '24 hours'
      ELSE interval '72 hours'
    END AS target_interval,
    CASE series_id % 6
      WHEN 0 THEN 'Database'
      WHEN 1 THEN 'Network'
      WHEN 2 THEN 'Identity'
      WHEN 3 THEN 'Endpoint'
      WHEN 4 THEN 'Email'
      ELSE 'Business Application'
    END AS generated_category,
    CASE series_id % 6
      WHEN 0 THEN 'database timeout during transaction processing'
      WHEN 1 THEN 'connection refused after DNS failure'
      WHEN 2 THEN 'authentication failed with access denied'
      WHEN 3 THEN 'endpoint agent reports out of memory'
      WHEN 4 THEN 'mail delivery timeout'
      ELSE 'application database error'
    END AS generated_problem
  FROM incident_source_data
)
INSERT INTO incidents (
  id,
  requester_user_id,
  device_id,
  title,
  description,
  category,
  service_name,
  priority,
  status,
  source,
  first_response_at,
  sla_deadline,
  resolved_at,
  closed_at,
  created_at,
  updated_at
)
SELECT
  series_id,
  ((series_id * 17 - 1) % 500) + 1,
  CASE WHEN series_id % 11 = 0 THEN NULL ELSE ((series_id * 37 - 1) % 1000) + 1 END,
  initcap(generated_problem) || ' #' || lpad((series_id % 250)::text, 3, '0'),
  'Deterministic service desk sample: ' || generated_problem
    || ' for service-' || ((series_id % 12) + 1) || '.',
  generated_category,
  'service-' || ((series_id % 12) + 1),
  generated_priority,
  generated_status,
  CASE series_id % 4
    WHEN 0 THEN 'PORTAL'::incident_source
    WHEN 1 THEN 'PHONE'::incident_source
    WHEN 2 THEN 'EMAIL'::incident_source
    ELSE 'MONITORING'::incident_source
  END,
  CASE
    WHEN series_id % 23 = 0 THEN NULL
    ELSE created_timestamp + (5 + (series_id % 180)) * interval '1 minute'
  END,
  created_timestamp + target_interval,
  CASE
    WHEN generated_status IN ('RESOLVED', 'CLOSED')
      THEN created_timestamp + (1 + (series_id % 96)) * interval '1 hour'
    ELSE NULL
  END,
  CASE
    WHEN generated_status = 'CLOSED'
      THEN created_timestamp + (2 + (series_id % 96)) * interval '1 hour'
    ELSE NULL
  END,
  created_timestamp,
  CASE
    WHEN generated_status = 'CLOSED'
      THEN created_timestamp + (2 + (series_id % 96)) * interval '1 hour'
    WHEN generated_status = 'RESOLVED'
      THEN created_timestamp + (1 + (series_id % 96)) * interval '1 hour'
    ELSE created_timestamp + (series_id % 48) * interval '1 hour'
  END
FROM prepared_incidents;

INSERT INTO incident_assignments (
  incident_id,
  technician_id,
  role,
  assigned_at,
  unassigned_at,
  created_at,
  updated_at
)
SELECT
  incident.id,
  ((incident.id * 13 - 1) % 100) + 1,
  'PRIMARY',
  incident.created_at + interval '5 minutes',
  CASE
    WHEN incident.status IN ('RESOLVED', 'CLOSED') THEN incident.resolved_at
    ELSE NULL
  END,
  incident.created_at + interval '5 minutes',
  coalesce(incident.resolved_at, incident.updated_at)
FROM incidents AS incident;

INSERT INTO incident_assignments (
  incident_id,
  technician_id,
  role,
  assigned_at,
  unassigned_at,
  created_at,
  updated_at
)
SELECT
  incident.id,
  ((incident.id * 13 + 16) % 100) + 1,
  'ESCALATION',
  incident.created_at + interval '30 minutes',
  CASE
    WHEN incident.status IN ('RESOLVED', 'CLOSED') THEN incident.resolved_at
    ELSE NULL
  END,
  incident.created_at + interval '30 minutes',
  coalesce(incident.resolved_at, incident.updated_at)
FROM incidents AS incident
WHERE incident.id % 7 = 0;

INSERT INTO incident_comments (
  incident_id,
  author_user_id,
  author_technician_id,
  body,
  is_internal,
  created_at,
  updated_at
)
SELECT
  incident.id,
  NULL,
  ((incident.id * 13 - 1) % 100) + 1,
  'Initial triage completed for incident ' || incident.id || '.',
  true,
  incident.created_at + interval '15 minutes',
  incident.created_at + interval '15 minutes'
FROM incidents AS incident
UNION ALL
SELECT
  incident.id,
  incident.requester_user_id,
  NULL,
  'Requester supplied deterministic reproduction details for incident ' || incident.id || '.',
  false,
  incident.created_at + interval '45 minutes',
  incident.created_at + interval '45 minutes'
FROM incidents AS incident;

SELECT setval(pg_get_serial_sequence('departments', 'id'), 20, true);
SELECT setval(pg_get_serial_sequence('users', 'id'), 500, true);
SELECT setval(pg_get_serial_sequence('devices', 'id'), 1000, true);
SELECT setval(pg_get_serial_sequence('technicians', 'id'), 100, true);
SELECT setval(pg_get_serial_sequence('software', 'id'), 50, true);
SELECT setval(pg_get_serial_sequence('software_installations', 'id'), 6000, true);
SELECT setval(pg_get_serial_sequence('incidents', 'id'), 20000, true);
SELECT setval(
  pg_get_serial_sequence('incident_assignments', 'id'),
  (SELECT max(id) FROM incident_assignments),
  true
);
SELECT setval(
  pg_get_serial_sequence('incident_comments', 'id'),
  (SELECT max(id) FROM incident_comments),
  true
);

REFRESH MATERIALIZED VIEW mv_monthly_incident_metrics;
ANALYZE;

COMMIT;

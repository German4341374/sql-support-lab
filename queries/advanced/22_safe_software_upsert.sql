-- Scenario 22: Idempotent software catalog upsert using the natural unique key.
BEGIN;

INSERT INTO software (vendor, name, latest_version, support_ends_on)
VALUES (
  'Example Vendor',
  'Support Agent',
  '3.2.1',
  date '2028-12-31'
)
ON CONFLICT (vendor, name)
DO UPDATE SET
  latest_version = EXCLUDED.latest_version,
  support_ends_on = EXCLUDED.support_ends_on
RETURNING id, vendor, name, latest_version;

ROLLBACK;

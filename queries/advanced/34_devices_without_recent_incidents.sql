-- Scenario 34: Anti-join for devices without incidents after a reporting cutoff.
SELECT
  device.id,
  device.asset_tag,
  device.status,
  device.type
FROM devices AS device
WHERE NOT EXISTS (
  SELECT 1
  FROM incidents AS incident
  WHERE incident.device_id = device.id
    AND incident.created_at >= timestamptz '2025-10-01 00:00:00+00'
)
ORDER BY device.asset_tag;

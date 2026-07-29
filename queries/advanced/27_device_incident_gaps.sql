-- Scenario 27: Time between consecutive incidents for each device.
WITH device_timeline AS (
  SELECT
    device_id,
    id AS incident_id,
    created_at,
    lag(created_at) OVER (
      PARTITION BY device_id
      ORDER BY created_at
    ) AS previous_incident_at
  FROM incidents
  WHERE device_id IS NOT NULL
)
SELECT
  device.asset_tag,
  timeline.incident_id,
  timeline.created_at,
  timeline.created_at - timeline.previous_incident_at AS gap_since_previous
FROM device_timeline AS timeline
JOIN devices AS device ON device.id = timeline.device_id
WHERE timeline.previous_incident_at IS NOT NULL
ORDER BY gap_since_previous
LIMIT 100;

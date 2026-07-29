-- Scenario 32: LATERAL join for the latest incident on each device.
SELECT
  device.asset_tag,
  latest_incident.id AS incident_id,
  latest_incident.title,
  latest_incident.status,
  latest_incident.created_at
FROM devices AS device
LEFT JOIN LATERAL (
  SELECT
    incident.id,
    incident.title,
    incident.status,
    incident.created_at
  FROM incidents AS incident
  WHERE incident.device_id = device.id
  ORDER BY incident.created_at DESC
  LIMIT 1
) AS latest_incident ON true
ORDER BY device.asset_tag
LIMIT 100;

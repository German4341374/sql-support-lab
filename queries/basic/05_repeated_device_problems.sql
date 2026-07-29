-- Scenario 05: Repeated categories affecting the same device.
SELECT
  device.asset_tag,
  incident.category,
  count(*) AS incident_count,
  min(incident.created_at) AS first_seen_at,
  max(incident.created_at) AS last_seen_at
FROM incidents AS incident
JOIN devices AS device ON device.id = incident.device_id
GROUP BY device.id, device.asset_tag, incident.category
HAVING count(*) >= 5
ORDER BY incident_count DESC, device.asset_tag
LIMIT 50;

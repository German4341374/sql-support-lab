-- Scenario 08: Devices with installed versions different from the supported latest version.
SELECT
  device.asset_tag,
  device.hostname,
  software.name,
  installation.installed_version,
  software.latest_version,
  installation.last_seen_at
FROM software_installations AS installation
JOIN devices AS device ON device.id = installation.device_id
JOIN software ON software.id = installation.software_id
WHERE installation.installed_version <> software.latest_version
ORDER BY installation.last_seen_at DESC, device.asset_tag
LIMIT 100;

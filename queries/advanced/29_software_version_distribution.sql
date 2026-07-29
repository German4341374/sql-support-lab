-- Scenario 29: Installed version distribution and upgrade requirement.
SELECT
  software.name,
  installation.installed_version,
  count(*) AS device_count,
  installation.installed_version <> software.latest_version AS upgrade_required
FROM software
JOIN software_installations AS installation
  ON installation.software_id = software.id
GROUP BY software.id, software.name, software.latest_version, installation.installed_version
ORDER BY software.name, device_count DESC;

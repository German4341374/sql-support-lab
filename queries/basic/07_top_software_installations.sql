-- Scenario 07: Most widely installed software products.
SELECT
  software.vendor,
  software.name,
  software.latest_version,
  count(*) AS installation_count,
  count(DISTINCT installation.device_id) AS device_count
FROM software
JOIN software_installations AS installation
  ON installation.software_id = software.id
GROUP BY software.id, software.vendor, software.name, software.latest_version
ORDER BY installation_count DESC, software.name
LIMIT 20;

-- Scenario 30: Incident arrival heatmap by ISO day and hour.
SELECT
  extract(isodow FROM created_at)::integer AS iso_day_of_week,
  extract(hour FROM created_at)::integer AS hour_of_day,
  count(*) AS incident_count
FROM incidents
GROUP BY
  extract(isodow FROM created_at)::integer,
  extract(hour FROM created_at)::integer
ORDER BY iso_day_of_week, hour_of_day;

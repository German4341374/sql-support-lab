-- Scenario 16: Window function for a seven-day rolling incident average.
WITH daily_counts AS (
  SELECT
    created_at::date AS incident_date,
    count(*) AS incident_count
  FROM incidents
  GROUP BY created_at::date
)
SELECT
  incident_date,
  incident_count,
  round(
    avg(incident_count) OVER (
      ORDER BY incident_date
      ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ),
    2
  ) AS seven_day_rolling_average
FROM daily_counts
ORDER BY incident_date;

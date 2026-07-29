-- Scenario 35: Generate a complete month series and zero-fill missing incident counts.
WITH month_series AS (
  SELECT generate_series(
    date '2024-01-01',
    date '2025-12-01',
    interval '1 month'
  )::date AS month
),
incident_totals AS (
  SELECT
    date_trunc('month', created_at)::date AS month,
    count(*) AS incident_count
  FROM incidents
  GROUP BY date_trunc('month', created_at)::date
)
SELECT
  month_series.month,
  coalesce(incident_totals.incident_count, 0) AS incident_count
FROM month_series
LEFT JOIN incident_totals USING (month)
ORDER BY month_series.month;

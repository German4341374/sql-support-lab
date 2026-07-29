-- Scenario 19: Median, p90, and p95 resolution times by priority.
SELECT
  priority,
  round(
    percentile_cont(0.50) WITHIN GROUP (
      ORDER BY extract(epoch FROM (resolved_at - created_at)) / 3600.0
    )::numeric,
    2
  ) AS p50_hours,
  round(
    percentile_cont(0.90) WITHIN GROUP (
      ORDER BY extract(epoch FROM (resolved_at - created_at)) / 3600.0
    )::numeric,
    2
  ) AS p90_hours,
  round(
    percentile_cont(0.95) WITHIN GROUP (
      ORDER BY extract(epoch FROM (resolved_at - created_at)) / 3600.0
    )::numeric,
    2
  ) AS p95_hours
FROM incidents
WHERE resolved_at IS NOT NULL
GROUP BY priority
ORDER BY priority;

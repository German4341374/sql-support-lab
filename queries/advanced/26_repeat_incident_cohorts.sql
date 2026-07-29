-- Scenario 26: Requester cohorts based on repeat incidents within 30 days.
WITH requester_timeline AS (
  SELECT
    requester_user_id,
    id,
    created_at,
    lag(created_at) OVER (
      PARTITION BY requester_user_id
      ORDER BY created_at
    ) AS previous_incident_at
  FROM incidents
),
requester_summary AS (
  SELECT
    requester_user_id,
    count(*) AS total_incidents,
    count(*) FILTER (
      WHERE created_at - previous_incident_at <= interval '30 days'
    ) AS repeats_within_30_days
  FROM requester_timeline
  GROUP BY requester_user_id
)
SELECT
  requester.full_name,
  summary.total_incidents,
  summary.repeats_within_30_days
FROM requester_summary AS summary
JOIN users AS requester ON requester.id = summary.requester_user_id
ORDER BY repeats_within_30_days DESC, summary.total_incidents DESC
LIMIT 30;

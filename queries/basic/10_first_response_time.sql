-- Scenario 10: First response time by priority, excluding unanswered incidents.
SELECT
  priority,
  count(*) AS answered_incidents,
  round(avg(extract(epoch FROM (first_response_at - created_at)) / 60.0), 2)
    AS average_first_response_minutes,
  round(max(extract(epoch FROM (first_response_at - created_at)) / 60.0), 2)
    AS maximum_first_response_minutes
FROM incidents
WHERE first_response_at IS NOT NULL
GROUP BY priority
ORDER BY priority;

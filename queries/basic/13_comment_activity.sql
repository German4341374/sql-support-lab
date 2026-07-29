-- Scenario 13: Incidents with the most comment activity.
SELECT
  incident.id,
  incident.title,
  count(comment.id) AS comment_count,
  min(comment.created_at) AS first_comment_at,
  max(comment.created_at) AS latest_comment_at
FROM incidents AS incident
JOIN incident_comments AS comment ON comment.incident_id = incident.id
GROUP BY incident.id, incident.title
ORDER BY comment_count DESC, latest_comment_at DESC
LIMIT 50;

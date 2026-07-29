-- Scenario 11: Assigned device inventory by department and device type.
SELECT
  department.name AS department,
  device.type,
  count(*) AS device_count,
  count(*) FILTER (WHERE device.warranty_until < date '2026-01-01')
    AS warranty_expired
FROM devices AS device
JOIN users AS assigned_user ON assigned_user.id = device.assigned_user_id
JOIN departments AS department ON department.id = assigned_user.department_id
GROUP BY department.name, device.type
ORDER BY department.name, device.type;

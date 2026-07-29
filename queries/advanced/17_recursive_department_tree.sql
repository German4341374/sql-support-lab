-- Scenario 17: Recursive CTE that expands the department hierarchy.
WITH RECURSIVE department_tree AS (
  SELECT
    id,
    parent_department_id,
    name,
    0 AS depth,
    ARRAY[name] AS path
  FROM departments
  WHERE parent_department_id IS NULL

  UNION ALL

  SELECT
    child.id,
    child.parent_department_id,
    child.name,
    parent.depth + 1,
    parent.path || child.name
  FROM departments AS child
  JOIN department_tree AS parent
    ON parent.id = child.parent_department_id
)
SELECT
  id,
  repeat('  ', depth) || name AS indented_name,
  depth,
  array_to_string(path, ' > ') AS hierarchy_path
FROM department_tree
ORDER BY path;

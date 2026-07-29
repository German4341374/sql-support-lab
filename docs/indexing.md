# Indexing Strategy

## Baseline indexes

The base schema indexes common foreign-key joins and operational access paths:

- users by department;
- devices by assigned user and type/status;
- incidents by requester, device, and creation time;
- comments by incident/time;
- software installations by software;
- assignments by incident and technician;
- audit entries by incident/time.

The unique active-primary assignment index also enforces a business invariant:
an incident can have only one current primary technician.

## Optimization indexes

Specialized indexes live in a separate migration so their effect can be
measured:

- a partial covering index for active Critical incidents;
- a partial covering SLA-deadline index for active incidents;
- a partial current-assignment index;
- a category/time/device recurring-problem index;
- a GIN full-text index.

## Trade-offs

Indexes consume disk, increase WAL, and add work to inserts and updates. A
portfolio schema with an index for every example would hide this trade-off.
These indexes are selected for repeatable support workflows and are justified
with captured plans.

The project does not force planner settings such as `enable_seqscan = off`.
Doing so would demonstrate index availability rather than realistic planner
choice.

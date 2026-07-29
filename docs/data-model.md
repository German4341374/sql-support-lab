# Data Model

## Service Desk boundaries

The model separates organizational ownership, inventory, support work, and
software state:

- departments form a self-referencing hierarchy;
- users belong to departments and may own devices;
- technicians are a separate workforce with support skills;
- incidents link a requester and optional affected device;
- comments support either a requester or technician author;
- assignments preserve technician routing history;
- software installations form a many-to-many relation between devices and
  products.

## State modeling

Stable state vocabularies use PostgreSQL enums. They provide compact storage,
strong validation, readable SQL, and predictable ordering behavior. SLA targets
use a lookup table because response and resolution intervals are configurable
business data.

## Time modeling

Operational timestamps use `timestamptz`. The seed and reporting cutoffs use
explicit UTC offsets. `created_at` and `updated_at` exist on all mutable domain
tables; triggers update `updated_at` during writes.

## Integrity examples

- an assigned device must reference a user;
- a resolved incident must have `resolved_at`;
- only a Closed incident may have `closed_at`;
- SLA deadline must follow incident creation;
- a comment has exactly one author type;
- an assignment cannot finish before it starts;
- a device/software pair may occur only once.

The audit table deliberately does not reference incidents. Keeping the foreign
key would either block incident deletion or delete the evidence it is meant to
preserve.

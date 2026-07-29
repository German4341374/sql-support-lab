## Summary

Describe the schema, query, optimization, or documentation change.

## Query-plan impact

Explain any index or planner effect. Include before/after evidence when query
behavior changes.

## Verification

- [ ] `bash scripts/check-layout.sh`
- [ ] `bash scripts/smoke-test.sh`
- [ ] `bash scripts/capture-plans.sh` when indexes or optimized queries changed
- [ ] No real credentials or personal data were added

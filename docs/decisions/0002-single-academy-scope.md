# 0002: Single academy, no ACADEMY entity
- Status: accepted
- Delivery: D1
- Date: 2026-10-07

## Context
The brief lists ACADEMY as a candidate entity ("physical/virtual academies"). The system is built for Maria's own academy, which has a single location.

## Options considered
1. Keep ACADEMY and relate students, classes and instructors to it. This allows multi-site support later.
2. Remove ACADEMY. The whole database describes one academy.

## Decision
Option 2. ACADEMY is removed. Enrollment becomes a binary many-to-many relationship STUDENT-DISCIPLINE (`ENROLLED_IN`), not a ternary with ACADEMY.

## Consequences
- Simpler model with no entity that would only ever have one row (a single-row entity adds no information).
- Multi-site support would require adding ACADEMY and a foreign key on CLASS, ENROLLED_IN and INSTRUCTOR. This is noted as out of scope.
- The ternary relationship requirement is covered by PROMOTION instead (ADR-0004).

## Related: FR-02, ADR-0004

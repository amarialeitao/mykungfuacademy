# 0003: PERSON specialization into STUDENT and INSTRUCTOR (overlapping, total)
- Status: accepted
- Delivery: D1
- Date: 2026-10-07

## Context
The brief lists STUDENT and INSTRUCTOR as separate entities. Both need the same identity data (name, email, phone, birth date). In this academy an instructor can also train as a student (confirmed by Maria).

## Options considered
1. Two independent entities with duplicated attributes. A person who teaches and trains would exist twice, with two emails that can drift apart.
2. One PERSON entity with a `role` attribute. This cannot express role-specific attributes or role-specific relationships cleanly.
3. Supertype PERSON with subtypes STUDENT and INSTRUCTOR.

## Decision
Option 3.
- **Overlapping (o):** a person can be both a student and an instructor.
- **Total (double line):** every person is at least one of them. The system has no "other" people.
- Shared attributes go in PERSON. Role-specific attributes and relationships go in the subtypes (for example, only STUDENT enrolls and only INSTRUCTOR teaches).

## Consequences
- Identity is stored once, so email uniqueness holds across roles.
- It enables rank lineage ("who promoted whom", backlog for D2). An instructor who also trains can receive promotions from another instructor.
- It requires a rule that an instructor cannot promote or evaluate themselves (BR-05).
- Mapping options (one table per class or a single table) are decided in D2.

## Related: FR-01, BR-01, BR-05, ADR-0004

# 0005: Generalize COMPETITION and CHALLENGE into EVENT (disjoint, total)
- Status: accepted
- Delivery: D1
- Date: 2026-10-07

## Context
The brief has COMPETITION and CHALLENGE as separate entities. Both have a name, start and end dates, a status, an organizing instructor and an optional discipline. They differ in their specific data (a competition has a venue, a level and a fee; a challenge has a metric, a target and a unit) and in how students take part (division, placement and medal versus progress).

## Options considered
1. Two unrelated entities, which duplicates the common attributes and relationships.
2. A single EVENT entity with a `type` attribute and nullable specific columns.
3. Supertype EVENT with subtypes COMPETITION and CHALLENGE.

## Decision
Option 3, **disjoint (d) and total**: every event is exactly one of the two. Common relationships (`ORGANIZES`, `EVENT_OF`) attach to EVENT. Participation attaches to each subtype (`COMPETES_IN`, `JOINS`) because its attributes differ.

## Consequences
- This gives a second specialization hierarchy that contrasts with ADR-0003: disjoint versus overlapping.
- Events can be listed in one place (calendar, organizer statistics).
- D2 must choose a mapping and enforce disjointness.

## Related: FR-23 to FR-25, BR-12

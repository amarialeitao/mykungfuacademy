# 0007: Entity refinements: PAYMENT, CRITERION and weak entities
- Status: accepted
- Delivery: D1
- Date: 2026-10-07

## Context
Several entities in the brief are either overloaded or relationships in disguise.

## Decision
1. **PAYMENT** is separated from SUBSCRIPTION (1:N). The brief's "subscription/payment state" mixes a contract with its monthly charges. Separating them makes payment history and overdue debt queryable.
2. **CRITERION** is added as a catalogue. The brief's "Evaluation Result" becomes the M:N relationship `SCORED_ON(EVALUATION, CRITERION)` with attribute `score`, so criteria are not typed as free text and scores stay comparable.
3. **Weak entities:** RANK (owner DISCIPLINE, partial key `rank_order`), PLAN_ITEM (owner TRAINING_PLAN, `item_no`) and SESSION_ACTIVITY (owner TRAINING_SESSION, `activity_no`). None of them exists without its owner.
4. **Relationships with attributes instead of entities:** the brief's "Student Belt", "Belt Technique Requirement", "Class Attendance", "Competition/Challenge Participation" and "Student Achievement" are M:N relationships (`PROMOTION`, `REQUIRES`, `ATTENDS`, `COMPETES_IN`, `JOINS`, `EARNS`). They have no identity of their own.
5. Out of scope (Maria's choice): rooms and competition categories. The division is an attribute of `COMPETES_IN`.

## Consequences
The model has 20 entities (3 weak, 4 subtypes) and 31 relationships. Rank lineage is deferred to D2 (backlog).

## Related: FR-20 to FR-22, FR-28 to FR-30, ADR-0004

# 0004: PROMOTION as a ternary relationship STUDENT × RANK × INSTRUCTOR
- Status: accepted
- Delivery: D1
- Date: 2026-10-07

## Context
A rank is not simply "held" by a student: it is **conferred** by a specific instructor on a specific date. The brief's "Student Belt" entity records only the student-rank pair. With a single academy (ADR-0002), the enrollment ternary is no longer available.

## Options considered
1. Binary STUDENT-RANK with an `instructor` attribute. This hides a relationship to another entity inside an attribute.
2. Two binaries, STUDENT-RANK and INSTRUCTOR-RANK. This loses information: knowing that Ana holds Yellow and that João conferred Yellow does not tell us whether João conferred Ana's Yellow.
3. A ternary PROMOTION(STUDENT, RANK, INSTRUCTOR) with attributes `promoted_on` and `remarks`.

## Decision
Option 3. All three participants take part simultaneously in one fact: "instructor I promoted student S to rank R on date D".
- Participation: STUDENT (0,N), RANK (0,N), INSTRUCTOR (0,N). All are partial: a new student has no promotion yet, and a rank or an instructor may have none.
- Functional constraint: the pair {student, rank} determines the instructor, because a student receives each rank at most once. This will become the key of the relationship in D2.

## Consequences
- The current rank of a student in a discipline is derived as the promotion with the highest `rank_order`. It is not stored, so it cannot become inconsistent.
- It enables D2 rules: next-rank-only (BR-04), qualified and not self (BR-05), eligibility by months and classes (BR-06).
- It enables rank lineage in D2 through a recursive query on promoter → promoted (backlog).

## Related: FR-07, FR-08, FR-09, FR-11, BR-04 to BR-06, ADR-0003

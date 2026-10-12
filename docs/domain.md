# MyKungFuAcademy: Domain (living document)

Last updated: 2026-10-07 (D1). Changes to this file require Maria's approval and an ADR.

## 1. Miniworld

MyKungFuAcademy is the management and training platform of a **single martial-arts academy** (ADR-0002). The academy teaches several **disciplines** (for example Kung Fu, Brazilian Jiu-Jitsu and Muay Thai). Each discipline has its own ordered **rank** system (belts or levels).

The people on the platform are **students**, **instructors**, or both (ADR-0003). A student **enrolls** in one or more disciplines. In each discipline the student attends scheduled **classes** taught by a qualified instructor, logs individual **training sessions**, and follows **training plans** that an instructor designs for a target rank. Each plan prescribes techniques from the academy's **technique catalogue**. Students also set personal **goals**.

Instructors **evaluate** students against a catalogue of **criteria**. When a student meets a rank's requirements (time at the current rank, classes attended, required techniques), an instructor **promotes** the student to the next rank (ADR-0004).

The academy runs **events** (ADR-0005). A **competition** is a tournament in which students compete in divisions and may win medals. A **challenge** is a community goal (for example "1,000 push-ups in October") that students join and track progress against. Students earn **achievements** (badges with points) that feed **leaderboards**.

Students hold a **subscription** (basic or premium) that is charged monthly through **payments**. A premium subscription unlocks premium instructional content.

**Hybrid narrative.** A relational core (PostgreSQL) manages academy operations and student progression. MongoDB (D3) will hold the flexible, high-volume or nested data: technique media content, wearable telemetry, free-form instructor feedback, the social activity feed and pre-computed training analytics.

## 2. Scope

**In scope (relational core, D1-D2):** people and roles, disciplines, ranks and requirements, techniques, goals, training plans and sessions, classes and attendance, evaluations, events (competitions and challenges), achievements, subscriptions and payments.

**Out of scope:** multiple academy locations, rooms and equipment, competition categories as entities, payroll, payment gateway integration, and the user interface. Planned for D3 (MongoDB): content, wearable data, feedback, social feed and analytics.

## 3. Assumptions

- A1. There is one academy and one currency. Monetary values are `NUMERIC` with 2 decimals.
- A2. A rank's requirements apply to the time and classes since the student's previous promotion in the same discipline.
- A3. A student's first rank in a discipline (order 1) is also recorded as a promotion, conferred at or after enrollment.
- A4. Classes are stored as dated occurrences. Recurring timetables are generated outside the database.
- A5. Leaderboards and current ranks are derived by queries, not stored.
- A6. There is exactly one head instructor, who manages ranks, requirements and criteria.

## 4. Business rules

| ID | Rule |
|---|---|
| BR-01 | Every person is a student, an instructor or both (total, overlapping). |
| BR-02 | Every student is enrolled in at least one discipline. |
| BR-03 | Ranks of a discipline are numbered 1, 2, 3 and so on without gaps (`rank_order`). |
| BR-04 | A student can only be promoted to rank 1, or to the rank immediately after their current one, in a discipline they are actively enrolled in. Each rank is received at most once. |
| BR-05 | The promoting instructor must be qualified in the rank's discipline and cannot be the promoted person. The same applies to evaluations. |
| BR-06 | A promotion requires at least `min_months` since the previous promotion and at least `min_classes` attended classes (present or late) of that discipline since then. |
| BR-07 | A technique required by a rank, prescribed in a plan item or practised in a session must belong to the same discipline as the rank, the plan's target rank or the student's enrollments, respectively. |
| BR-08 | Attendance of a class cannot exceed its capacity. Only students enrolled in the class's discipline can attend. Cancelled classes have no attendance. |
| BR-09 | An instructor cannot teach two classes that overlap in time. |
| BR-10 | A criterion score is between 0 and the criterion's `max_score`. A grading exam has an outcome (pass or fail). |
| BR-11 | Every date range is valid: `end_date >= start_date` for plans, events and subscriptions. |
| BR-12 | Every event is exactly one of competition or challenge (disjoint, total). |
| BR-13 | Medal is consistent with placement: 1 → gold, 2 → silver, 3 → bronze, otherwise none. A challenge has `completed_on` set only when progress ≥ target. |
| BR-14 | A student has at most one active subscription at any time. |
| BR-15 | A payment with status `paid` has `paid_at`. Other statuses have none. |
| BR-16 | An achievement is earned at most once per student. |
| BR-17 | Students under 18 must have an emergency contact and phone. |

## 5. Entities and relationships

See the data dictionary in the D1 report (`deliveries/D1/report/report.md`, §4) and the diagram `deliveries/D1/er/model.drawio`. Summary: 20 entity sets (3 weak, 2 specializations with 4 lower-level entity sets) and 31 relationship sets, including the ternary *promotion*. Notation: course standard, lecture T4 (ADR-0008).

## 6. Glossary

| Term | Meaning |
|---|---|
| Discipline | A martial art taught at the academy, with its own rank system. |
| Rank / belt | An ordered level inside a discipline (for example White → Yellow → Green). |
| Promotion | The act of an instructor conferring the next rank on a student. |
| Grading exam | An evaluation whose outcome decides a promotion. |
| Form (taolu / kata) | A choreographed sequence of techniques, catalogued as a technique of category `form`. |
| Training plan | A set of techniques with volume and frequency that an instructor prescribes for a target rank. |
| Training session | Individual practice logged by a student (as opposed to a class). |
| Class | A scheduled group lesson of one discipline, taught by one instructor. |
| Event | A competition or a challenge. |
| Division | The weight, age or rank bracket in which a student competes. |
| Discriminator | Attribute that, together with the owner's key, identifies a weak entity set (for example `rank_order` of *rank*). |
| Rank lineage | The chain of instructors who promoted each other (planned for D2). |

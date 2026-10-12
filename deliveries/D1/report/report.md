---
title: "MyKungFuAcademy's D1: Requirements Analysis and Conceptual Modeling"
subtitle: "Introduction to Database Systems 2026/27 · Group 12 (IBD2627_D1_Group12)"
author: "Maria Leitão"
date: "October 2026"
---

# Domain description

**MyKungFuAcademy** is the management and training platform of a single martial-arts academy that teaches several **disciplines** (for example Kung Fu, Brazilian Jiu-Jitsu and Muay Thai). Each discipline has its own ordered **rank** system (belts). The people on the platform are **students**, **instructors**, or both: an instructor may also train.

A student **enrolls** in one or more disciplines, attends scheduled **classes**, logs individual **training sessions**, follows **training plans** that an instructor designs for a target rank, and sets personal **goals**. Plans, rank requirements and logged activities all refer to a shared **technique catalogue**. Instructors **evaluate** students against a catalogue of **criteria**. When the requirements of the next rank are met (time at the current rank, classes attended, required techniques), an instructor **promotes** the student.

The academy runs **events**: **competitions**, in which students compete in a division and may win medals, and **challenges**, community goals that students join and track progress against. Students earn **achievements** (badges with points) that feed **leaderboards**. A **subscription** (basic or premium) is charged monthly through **payments**. Premium unlocks premium instructional content.

*Example.* Maria is a Yellow Belt in Kung Fu and wants to reach Green. Her instructor creates a plan with the forms and techniques that Green requires. Maria attends classes and logs her training, and she is evaluated in a grading exam. When she has 4 months at Yellow and 30 classes attended, the instructor records her promotion to Green.

**Scope and assumptions.** There is one academy with a single location and one currency. This deliverable models the **relational core**, which will be implemented in PostgreSQL in D2. Flexible or high-volume data is planned for MongoDB in D3 (§6). The model leaves out rooms, payroll, payment gateways and the user interface. Current ranks and leaderboards are **derived** by queries, not stored. A rank's requirements count from the student's previous promotion in the same discipline. The first rank of a discipline is also recorded as a promotion.

# Stakeholders

| Stakeholder | Role in the system | Main interests |
|:--------------|:----------------------------|:------------------------------------------|
| Student | Trains, logs sessions, joins events | See current rank and what is missing for the next one; follow plans; compare on leaderboards; access premium content |
| Parent / guardian | Responsible for minor students | Emergency contact is on file; payments; child's attendance and progress |
| Instructor | Teaches classes, evaluates, designs plans, promotes | Class rosters and attendance; evaluation history; plan adherence of their students |
| Head instructor (owner) | Defines ranks, requirements and criteria | Who is eligible for promotion; class occupancy; retention; revenue |
| Administrator / front desk | Registrations, timetable, billing | Correct enrollments; no scheduling conflicts; overdue payments |
| Event organizer (an instructor) | Runs competitions and challenges | Registrations, results and engagement |
| Developer / DBA | Builds and operates the database | Integrity, performance, backups, evolvability |

# Requirements

## Functional requirements

Actors: **Adm**inistrator, **Head** instructor, **Instr**uctor, **Stud**ent, **Sys**tem (automatic). Every requirement can be verified pass/fail.

| ID | Requirement |
|:----|:------------------------------------------------------------------------|
| | ***A. People and enrollment*** |
| FR-01 | The system must allow the administrator to register a person as a student, an instructor or both, storing name, email, birth date and the role-specific data, and must reject an email that already exists. |
| FR-02 | The system must allow the administrator to enroll a student in one or more disciplines, recording the enrollment date and status (active, paused, ended). |
| FR-03 | The system must allow the administrator to record which disciplines an instructor is qualified in, with the certification and the date it was obtained. |
| FR-04 | The system must allow the administrator to change a student's status (active, suspended, inactive) without deleting any of the student's history. |
| | ***B. Ranks and techniques*** |
| FR-05 | The system must allow the head instructor to define, per discipline, an ordered list of ranks with name, colour, minimum months and minimum classes. |
| FR-06 | The system must allow the head instructor to link techniques of the same discipline to a rank as requirements, each with a minimum proficiency (1-5). |
| FR-07 | The system must allow an instructor qualified in the discipline to record a student's promotion to a rank, with date and remarks. |
| FR-08 | The system must reject a promotion that skips a rank, repeats a rank already held, is in a discipline where the student is not actively enrolled, or is recorded by the promoted person. |
| FR-09 | The system must allow a student to view their current rank in each enrolled discipline and what is missing for the next one (months, classes, required techniques). |
| FR-10 | The system must allow students and instructors to search the technique catalogue by discipline, category and difficulty. |
| FR-11 | The system must allow the head instructor to list, per discipline, the students who meet the time and class requirements of their next rank. |
| | ***C. Training*** |
| FR-12 | The system must allow a student to create, edit and close goals (achieved or abandoned), optionally linked to a target rank and a target date. |
| FR-13 | The system must allow an instructor to create a training plan for a student towards a target rank, listing techniques with sets, reps, duration and sessions per week. |
| FR-14 | The system must allow a student to log a training session with start time, duration, perceived effort (1-10), an optional plan, and the techniques practised. |
| FR-15 | The system must show the student and the plan's instructor the percentage of the plan's prescribed weekly sessions completed in the last 4 weeks. |
| | ***D. Classes and attendance*** |
| FR-16 | The system must allow the administrator to schedule a class (discipline, instructor, start, duration, capacity, level), rejecting it if the instructor already teaches an overlapping class. |
| FR-17 | The system must allow the instructor of a class to record each student's attendance as present, late, absent or excused. |
| FR-18 | The system must reject attendance that exceeds the class capacity, belongs to a cancelled class, or is for a student not enrolled in the class's discipline. |
| FR-19 | The system must allow the administrator to list each class's occupancy rate (attendees / capacity) per discipline and instructor for a chosen period. |
| | ***E. Evaluation*** |
| FR-20 | The system must allow the head instructor to create, edit and retire evaluation criteria, each with a maximum score. |
| FR-21 | The system must allow a qualified instructor to record an evaluation of a student in a discipline, with a score per criterion and, for grading exams, a pass/fail outcome. |
| FR-22 | The system must allow a student to view their evaluation history and their average score per criterion. |
| | ***F. Events, achievements and leaderboards*** |
| FR-23 | The system must allow an instructor to create an event as either a competition (venue, level, entry fee) or a challenge (metric, target value, unit). |
| FR-24 | The system must allow the administrator to register a student in a competition with a division and later record the placement and medal. |
| FR-25 | The system must allow a student to join an open challenge and update their progress, setting the completion date automatically when the target is reached. |
| FR-26 | The system must award an achievement to a student, with the date, when the achievement's rule threshold is reached, and at most once per student. |
| FR-27 | The system must allow students to view a leaderboard per discipline and period, ranked by achievement points, classes attended or challenge progress. |
| | ***G. Subscriptions and payments*** |
| FR-28 | The system must allow the administrator to create, pause and cancel a basic or premium subscription for a student, rejecting a second active one. |
| FR-29 | The system must allow the administrator to record a payment of a subscription with amount, due date, method and status. |
| FR-30 | The system must allow the administrator to list the students with pending payments past their due date and the total amount owed by each. |
| FR-31 | The system must grant access to premium content only to students whose premium subscription is active on the day of access. |

## Non-functional requirements

| ID | Quality | Requirement |
|:-------|:----------|:---------------------------------------------------------|
| NFR-01 | Performance | 95% of student-progress queries (FR-09, FR-15) return in < 500 ms with 5,000 students, 500,000 attendance rows and 200,000 sessions. |
| NFR-02 | Performance | Recording the attendance of a full class (40 students) completes in < 1 s. |
| NFR-03 | Scalability | At 10× the NFR-01 volume, no schema change is needed and NFR-01 latency grows by ≤ 2×. |
| NFR-04 | Integrity | 100% of business rules BR-02 to BR-17 are enforced by the DBMS (constraints/triggers); validation queries return 0 violating rows after data load. |
| NFR-05 | Security | Personal data (email, phone, birth date, emergency contact) is readable only by administrator and instructor roles; a student reads only their own rows (100% of role tests pass). |
| NFR-06 | Recoverability | Daily full backup; data loss ≤ 24 h (RPO); full restore at reference volume ≤ 30 min (RTO). |
| NFR-07 | Auditability | 100% of inserts/updates on promotions, evaluations and payments record author and timestamp, kept ≥ 5 years. |
| NFR-08 | Portability | The database is created and loaded from scripts on a fresh Docker Compose environment in < 5 min with no manual steps. |
| NFR-09 | Freshness | Leaderboards reflect a new attendance or achievement within 60 s. |

## Data requirements and business rules

The entities, attributes, data types and attribute-level constraints are listed in the data dictionary (§4.4). Rules that span several entities:

| ID | Business rule |
|:----|:------------------------------------------------------------------------|
| BR-01 | Every person is a student, an instructor or both (total, overlapping). |
| BR-02 | Every student is enrolled in at least one discipline. |
| BR-03 | Ranks of a discipline are numbered 1, 2, 3 and so on with no gaps (`rank_order`). |
| BR-04 | A student can only be promoted to rank 1, or to the rank right after their current one, in a discipline where they are actively enrolled; each rank is received once. |
| BR-05 | The promoting or evaluating instructor must be qualified in the discipline and must not be the student. |
| BR-06 | A promotion requires ≥ `min_months` since the previous promotion and ≥ `min_classes` classes attended (present or late) in that discipline since then. |
| BR-07 | Techniques required by a rank, prescribed in a plan item or practised in a session belong to the discipline of that rank, of the plan's target rank, or to one of the student's enrolled disciplines. |
| BR-08 | Class attendance ≤ capacity; only students enrolled in the class's discipline can attend; a cancelled class has no attendance. |
| BR-09 | An instructor cannot teach two classes that overlap in time. |
| BR-10 | A score lies between 0 and the criterion's `max_score`; a grading exam has a pass/fail outcome. |
| BR-11 | Every date range is valid: `end_date ≥ start_date` (plans, events, subscriptions). |
| BR-12 | Every event is exactly one of competition or challenge (disjoint, total). |
| BR-13 | Medal matches placement (1 gold, 2 silver, 3 bronze, otherwise none); a challenge's `completed_on` is set only when progress ≥ target. |
| BR-14 | A student has at most one active subscription at any time. |
| BR-15 | A payment has `paid_at` if and only if its status is `paid`. |
| BR-16 | An achievement is earned at most once per student. |
| BR-17 | Students under 18 have an emergency contact and phone. |

# Conceptual model

## Notation and overview

The ER diagram (Figure 1, editable file `er/model.drawio`) follows the notation taught in the course (lecture T4 [2], based on Silberschatz et al. [1]):

- An **entity set** is a rectangle with its name in the header band and its attributes listed inside, written as `name : TYPE`. The primary key is underlined.
- A **weak entity set** is a double rectangle. Its **discriminator** has a dashed underline, and its **identifying relationship set** is a double diamond.
- A **relationship set** is a diamond. Its own attributes go in a rectangle linked to the diamond by a dashed line.
- **Cardinality limits** `l..h` are written on the line of each entity set: the minimum and maximum number of times one entity takes part in the relationship set (`*` = many). For example, a *student* takes part in *enrolled_in* `1..*` times. A **double line** marks total participation (l ≥ 1).
- **Composite** attributes list their components indented below them, and **derived** attributes end in `()`.
- **Specialization** uses hollow arrows pointing to the higher-level entity set: one arrow per subtype for overlapping, a single joined arrow for disjoint. A total completeness constraint is annotated with "total".

The model has **20 entity sets**: 13 strong, **3 weak** (*rank*, *plan_item*, *session_activity*) and 4 lower-level entity sets in **2 specializations**. It has **31 relationship sets**: 1 ternary, 3 identifying, and 9 with descriptive attributes. Every entity set takes part in at least one relationship set. Following the course rule on redundant attributes, no entity set repeats the key of another entity set it is related to, because each such link is expressed by a relationship set.



## Specialization, ternary relationship and weak entity sets

**person → {student, instructor}: overlapping, total.** The specialization was obtained by *generalization*: students and instructors shared name, email, phone and birth date, so these attributes moved to *person*. The same person can teach one discipline and train in another, so the specialization is overlapping (two arrows). It is also total, because the system has no other kind of person. The lower-level entity sets inherit all the attributes of *person* and have their own attributes and relationship sets: only students enroll, only instructors teach.

**event → {competition, challenge}: disjoint, total.** Both share a name, dates, a status, an organizer and a discipline. They differ in their own attributes and in how students take part: *competes_in* records division, placement and medal, while *joins* records progress. An event is exactly one of the two (single arrow, "total").

**promotion(student, rank, instructor)**, with `promoted_on` and `remarks`, records one fact: "instructor *I* promoted student *S* to rank *R* on date *D*". The course recommends binary relationships when possible. Here, two binaries (*student*-*rank* and *instructor*-*rank*) would lose information: from "Ana holds Yellow" and "João conferred Yellow" we cannot tell whether João promoted Ana. Each participant has cardinality limits `0..*`. The primary key of the relationship set is {student, rank}, because each rank is received at most once (BR-04). The current rank of a student is derived as the promotion with the highest `rank_order`.

**Weak entity sets.** A *rank* only exists within its *discipline* and is identified by the discipline's key plus the discriminator `rank_order` (identifying relationship set *has_rank*). The same holds for *plan_item* within its plan (`item_no`) and *session_activity* within its session (`activity_no`).

**Entity sets vs. relationship sets.** Several candidates from the brief ("Student Belt", "Class Attendance", "Evaluation Result", "Student Achievement", the participation entities) have no identity of their own. They are modeled as M:N relationship sets with descriptive attributes, and each one holds a single value per pair, so no multivalued relationship attribute is needed. *payment* is separated from *subscription* so that payment history and overdue debt can be queried. *criterion* is an entity set, not a multivalued attribute, because it carries its own data (`max_score`).

## Entity justification

Each of the 20 entity sets exists for a reason that a relationship set or an attribute could not cover:

- *person*: Higher-level entity set holding identity data shared by students and instructors (avoids duplicating people who both train and teach).
- *student*: Person who trains; owns goals, sessions, attendance, results and subscriptions.
- *instructor*: Person who teaches, evaluates, designs plans, organizes events and confers ranks.
- *discipline*: Martial art taught at the academy (Kung Fu, BJJ, Muay Thai, etc.); owns its own rank system.
- *rank*: Belt/level; weak entity because a rank (e.g. 'Yellow', order 3) only exists inside its discipline.
- *technique*: Catalogue item referenced by rank requirements, plans and logged activities. Rich media lives in MongoDB (D3).
- *goal*: Student objective, optionally tied to a target rank (e.g. 'reach Green belt by June').
- *training_plan*: Personalized plan an instructor designs for one student towards a target rank.
- *plan_item*: One prescribed technique/exercise of a plan; weak because it has no meaning outside its plan.
- *training_session*: Individual training a student logs outside class (actual work done, vs. the plan).
- *session_activity*: What was practised in a session; weak entity of *training_session*.
- *class*: One scheduled group lesson (dated occurrence) of a discipline.
- *evaluation*: Formal assessment of a student by an instructor in a discipline.
- *criterion*: Evaluation criterion catalogue; keeps scores comparable across evaluations.
- *event*: Higher-level entity set for competitions and challenges (shared identity, dates, organizer, discipline).
- *competition*: External or internal tournament where students compete in divisions.
- *challenge*: Community goal students join and track progress against.
- *achievement*: Badge/milestone with a measurable rule; points feed leaderboards.
- *subscription*: Membership contract; premium unlocks premium content (stored in MongoDB, D3).
- *payment*: Monthly charge of a subscription; separated so payment history and overdue debt are queryable.

## Data dictionary

Data types are conceptual PostgreSQL types. **(PK)** = primary key (underlined in the diagram). Lower-level entity sets inherit the key and attributes of the higher-level one. A weak entity set is identified by its owner's key plus its discriminator. ↳ marks a component of a composite attribute. Enumerated domains are listed as `a / b / c`.

| Entity set | Attributes : type | Constraints / domain |
|:---------|:---------------------|:-------------------|
| *person* | **`person_id`** (PK) INTEGER; `name` (composite); ↳ `first_name` VARCHAR(50); ↳ `last_name` VARCHAR(50); `email` VARCHAR(120); `phone` VARCHAR(20); `birth_date` DATE; `age()` INTEGER (derived); `registered_at` TIMESTAMP | `email`: unique; matches user@domain; `phone`: E.164 format; `birth_date`: person is at least 4 years old; `age()`: derived from birth_date; `registered_at`: default now |
| *student* ⊂ *person* | *(inherits all attributes of person; key person_id)*; `student_number` CHAR(8); `join_date` DATE; `status` VARCHAR(10); `emergency_contact` (composite); ↳ `contact_name` VARCHAR(100); ↳ `contact_phone` VARCHAR(20) | `student_number`: unique; 'S' + 7 digits; `status`: active / suspended / inactive; `emergency_contact`: required if age() < 18 |
| *instructor* ⊂ *person* | *(inherits all attributes of person; key person_id)*; `hire_date` DATE; `bio` TEXT; `hourly_rate` NUMERIC(6,2); `is_head` BOOLEAN | `hourly_rate`: >= 0; `is_head`: exactly one head instructor |
| *discipline* | **`discipline_id`** (PK) SMALLINT; `name` VARCHAR(50); `origin` VARCHAR(50); `description` TEXT | `name`: unique |
| *rank* (weak) | *(identified by owner discipline: key discipline_id, rank_order)*; `rank_order` (discriminator) SMALLINT; `name` VARCHAR(40); `color` VARCHAR(20); `min_months` SMALLINT; `min_classes` SMALLINT | `rank_order`: >= 1; consecutive per discipline; `name`: unique per discipline; `min_months`: >= 0; time at previous rank; `min_classes`: >= 0; classes since previous rank |
| *technique* | **`technique_id`** (PK) INTEGER; `name` VARCHAR(80); `category` VARCHAR(20); `difficulty` SMALLINT; `description` TEXT | `name`: unique per discipline; `category`: strike / kick / block / stance / form / throw / grappling / conditioning; `difficulty`: 1..5 |
| *goal* | **`goal_id`** (PK) INTEGER; `title` VARCHAR(100); `target_date` DATE; `status` VARCHAR(10); `created_on` DATE | `target_date`: >= created_on; `status`: open / achieved / abandoned |
| *training_plan* | **`plan_id`** (PK) INTEGER; `title` VARCHAR(100); `start_date` DATE; `end_date` DATE; `status` VARCHAR(10) | `end_date`: >= start_date; `status`: draft / active / completed / cancelled |
| *plan_item* (weak) | *(identified by owner training_plan: key plan_id, item_no)*; `item_no` (discriminator) SMALLINT; `sets` SMALLINT; `reps` SMALLINT; `duration_min` SMALLINT; `per_week` SMALLINT | `item_no`: >= 1; `sets`: >= 1; `reps`: >= 1; `duration_min`: 1..240; `per_week`: 1..7 |
| *training_session* | **`session_id`** (PK) INTEGER; `started_at` TIMESTAMP; `duration_min` SMALLINT; `effort` SMALLINT; `notes` TEXT | `started_at`: not in the future; `duration_min`: 1..480; `effort`: 1..10 (perceived effort) |
| *session_activity* (weak) | *(identified by owner training_session: key session_id, activity_no)*; `activity_no` (discriminator) SMALLINT; `reps` SMALLINT; `duration_min` SMALLINT; `self_rating` SMALLINT | `activity_no`: >= 1; `reps`: >= 1; `duration_min`: >= 1; `self_rating`: 1..5 |
| *class* | **`class_id`** (PK) INTEGER; `title` VARCHAR(80); `starts_at` TIMESTAMP; `duration_min` SMALLINT; `capacity` SMALLINT; `level` VARCHAR(12); `status` VARCHAR(10) | `duration_min`: 30..180; `capacity`: 1..40; `level`: beginner / intermediate / advanced / all; `status`: scheduled / held / cancelled |
| *evaluation* | **`evaluation_id`** (PK) INTEGER; `evaluated_on` DATE; `type` VARCHAR(12); `outcome` VARCHAR(6); `comments` TEXT | `type`: periodic / grading_exam; `outcome`: pass / fail (grading_exam only) |
| *criterion* | **`criterion_id`** (PK) SMALLINT; `name` VARCHAR(50); `description` TEXT; `max_score` SMALLINT | `name`: unique (e.g. technique, stamina); `max_score`: > 0 |
| *event* | **`event_id`** (PK) INTEGER; `name` VARCHAR(100); `start_date` DATE; `end_date` DATE; `status` VARCHAR(10) | `end_date`: >= start_date; `status`: planned / open / closed / cancelled |
| *competition* ⊂ *event* | *(inherits all attributes of event; key event_id)*; `venue` VARCHAR(100); `level` VARCHAR(13); `entry_fee` NUMERIC(6,2) | `level`: club / regional / national / international; `entry_fee`: >= 0 |
| *challenge* ⊂ *event* | *(inherits all attributes of event; key event_id)*; `metric` VARCHAR(40); `target_value` NUMERIC(8,2); `unit` VARCHAR(15) | `metric`: e.g. push-ups, training minutes; `target_value`: > 0 |
| *achievement* | **`achievement_id`** (PK) SMALLINT; `name` VARCHAR(60); `rule_type` VARCHAR(20); `threshold` INTEGER; `points` SMALLINT | `name`: unique; `rule_type`: attendance / streak / promotion / medal / challenge; `threshold`: > 0; `points`: >= 0 (leaderboards) |
| *subscription* | **`subscription_id`** (PK) INTEGER; `plan_type` VARCHAR(8); `monthly_fee` NUMERIC(6,2); `start_date` DATE; `end_date` DATE; `status` VARCHAR(10) | `plan_type`: basic / premium; `monthly_fee`: >= 0; `end_date`: >= start_date; `status`: active / paused / cancelled / expired |
| *payment* | **`payment_id`** (PK) INTEGER; `amount` NUMERIC(7,2); `due_date` DATE; `paid_at` TIMESTAMP; `method` VARCHAR(13); `status` VARCHAR(8) | `amount`: > 0; `paid_at`: required if status = paid; `method`: card / cash / bank_transfer / direct_debit; `status`: pending / paid / failed / refunded |

## Relationship sets

The primary key of each relationship set follows the course rules. M:N: the union of the participants' keys. 1:N or N:1: the key of the entity set that takes part at most once (`..1`). Identifying: the key of the weak entity set. Ternary *promotion*: {student, rank}.

| Relationship set | Participation (l..h) | Attributes | Primary key |
|:----------|:-----------------------|:-------------|:-----------------|
| *enrolled_in* | *student* `1..*`, *discipline* `0..*` | `enrolled_on` DATE, `status` VARCHAR(8) | student.person_id, discipline_id |
| *qualified_in* | *instructor* `1..*`, *discipline* `0..*` | `since` DATE, `certification` VARCHAR(80) | instructor.person_id, discipline_id |
| *has_rank* (identifying) | *discipline* `1..*`, *rank* `1..1` | - | discipline_id, rank_order |
| *belongs_to* | *technique* `1..1`, *discipline* `0..*` | - | technique_id |
| *requires* | *rank* `0..*`, *technique* `0..*` | `min_proficiency` SMALLINT | discipline_id, rank_order, technique_id |
| *promotion* (ternary) | *student* `0..*`, *rank* `0..*`, *instructor* `0..*` | `promoted_on` DATE, `remarks` TEXT | student.person_id, discipline_id, rank_order |
| *sets* | *student* `0..*`, *goal* `1..1` | - | goal_id |
| *targets* | *goal* `0..1`, *rank* `0..*` | - | goal_id |
| *follows* | *student* `0..*`, *training_plan* `1..1` | - | plan_id |
| *designs* | *instructor* `0..*`, *training_plan* `1..1` | - | plan_id |
| *aims_at* | *training_plan* `1..1`, *rank* `0..*` | - | plan_id |
| *contains* (identifying) | *training_plan* `1..*`, *plan_item* `1..1` | - | plan_id, item_no |
| *prescribes* | *plan_item* `1..1`, *technique* `0..*` | - | plan_id, item_no |
| *logs* | *student* `0..*`, *training_session* `1..1` | - | session_id |
| *executes* | *training_session* `0..1`, *training_plan* `0..*` | - | session_id |
| *includes* (identifying) | *training_session* `1..*`, *session_activity* `1..1` | - | session_id, activity_no |
| *practises* | *session_activity* `1..1`, *technique* `0..*` | - | session_id, activity_no |
| *teaches* | *instructor* `0..*`, *class* `1..1` | - | class_id |
| *class_of* | *class* `1..1`, *discipline* `0..*` | - | class_id |
| *attends* | *student* `0..*`, *class* `0..*` | `status` VARCHAR(8), `checked_in_at` TIMESTAMP | student.person_id, class_id |
| *conducts* | *instructor* `0..*`, *evaluation* `1..1` | - | evaluation_id |
| *undergoes* | *student* `0..*`, *evaluation* `1..1` | - | evaluation_id |
| *assesses* | *evaluation* `1..1`, *discipline* `0..*` | - | evaluation_id |
| *scored_on* | *evaluation* `1..*`, *criterion* `0..*` | `score` NUMERIC(4,1) | evaluation_id, criterion_id |
| *organizes* | *instructor* `0..*`, *event* `1..1` | - | event_id |
| *event_of* | *event* `0..1`, *discipline* `0..*` | - | event_id |
| *competes_in* | *student* `0..*`, *competition* `0..*` | `division` VARCHAR(40), `placement` SMALLINT, `medal` VARCHAR(6) | student.person_id, event_id |
| *joins* | *student* `0..*`, *challenge* `0..*` | `joined_on` DATE, `progress` NUMERIC(8,2), `completed_on` DATE | student.person_id, event_id |
| *earns* | *student* `0..*`, *achievement* `0..*` | `earned_on` DATE | student.person_id, achievement_id |
| *holds* | *student* `0..*`, *subscription* `1..1` | - | subscription_id |
| *settles* | *subscription* `0..*`, *payment* `1..1` | - | payment_id |

# Exploratory queries

Each question crosses at least three entities and maps to the functional requirements it validates. The full list, with the entities involved and an implementation hint for D2, is in `queries.md`.

**Q1. Promotion eligibility.** Per discipline, which actively enrolled students meet both the minimum months and the minimum classes of their *next* rank, and who conferred their current rank?
*Comment:* the head instructor's main operational question. It takes each student's latest promotion per discipline, finds the next `rank_order`, and counts classes attended (present or late) in that discipline since that promotion. *Entities:* *student*, *enrolled_in*, *promotion*, *rank*, *instructor*, *attends*, *class*. *Supports:* FR-11, FR-09.

**Q2. Neglected required techniques.** For each student, which techniques required by their next rank have not been practised in any logged session in the last 60 days?
*Comment:* an anti-join between the rank requirements and the session activities. It tells the instructor what the next plan should focus on. *Entities:* *promotion*, *rank*, *requires*, *technique*, *training_session*, *session_activity*. *Supports:* FR-06, FR-09, FR-14.

**Q3. Time between ranks.** Per discipline and rank, what is the average number of days students needed to reach it from the previous rank, and which instructor conferred the most promotions in the last 12 months?
*Comment:* it pairs consecutive promotions of the same student and discipline. This tests whether `min_months` is realistic. *Entities:* *promotion*, *rank*, *discipline*, *instructor*, *person*. *Supports:* FR-05, FR-07.

**Q4. Under-used classes.** Over the last 6 months, which instructor and level combinations per discipline have an average class occupancy below 50%?
*Comment:* cancelled classes are excluded. Only present and late attendance counts. Occupancy is attendees divided by capacity, averaged per group. *Entities:* *class*, *attends*, *instructor*, *discipline*. *Supports:* FR-19, FR-17.

**Q5. Regression alerts.** Which students' score in any criterion dropped by more than 20% of that criterion's maximum between their two most recent evaluations in the same discipline?
*Comment:* the score is normalized by `max_score` so that criteria with different scales are comparable. *Entities:* *student*, *evaluation*, *scored_on*, *criterion*, *discipline*. *Supports:* FR-21, FR-22.

**Q6. Plan adherence.** For every active training plan, what share of the prescribed weekly sessions was logged in the last 4 weeks, and how does each student rank among the students of the same designing instructor?
*Comment:* the expected number of sessions is the largest `per_week` among the plan items × 4. Only sessions linked to the plan count. *Entities:* *training_plan*, *plan_item*, *training_session*, *student*, *instructor*. *Supports:* FR-13, FR-15.

**Q7. Leaderboard.** Who are the top 10 students per discipline by achievement points earned this calendar year, and what is each one's current rank in that discipline?
*Comment:* achievements are not tied to a discipline, so each student appears in the leaderboard of every discipline they are actively enrolled in. Ties share a position. *Entities:* *student*, *earns*, *achievement*, *enrolled_in*, *promotion*, *rank*. *Supports:* FR-26, FR-27.

**Q8. Competition results and progression.** Did medallists compete sooner after their last promotion than non-medallists? For each competition, compare the average number of months since the last promotion in the competition's discipline.
*Comment:* it links event results to progression. Competitions without a discipline are excluded. *Entities:* *competition*, *event*, *competes_in*, *student*, *promotion*, *rank*, *discipline*. *Supports:* FR-24, FR-07.

**Q9. Overdue but active.** Which premium subscribers have a payment overdue by more than 15 days but attended at least one class in the last 30 days, and how much does each one owe?
*Comment:* a billing follow-up list for the front desk. It crosses billing data with attendance. *Entities:* *student*, *subscription*, *payment*, *attends*, *class*. *Supports:* FR-30, FR-31, FR-17.

**Q10. Goal success rate.** For goals linked to a target rank whose target date has passed, what percentage were reached on time (a promotion to that rank on or before the target date), per discipline?
*Comment:* it measures how realistic student goals are. Abandoned goals are reported separately. *Entities:* *goal*, *student*, *rank*, *discipline*, *promotion*. *Supports:* FR-12, FR-07.


# Planned NoSQL data (D3)

MongoDB will store the data that is schema-variable, nested or high-volume: `technique_content` (videos, articles and step lists per technique, with variable media metadata), `wearable_activity` (heart-rate and GPS time series per training session), `instructor_feedback` (free-form, threaded observations on techniques), `social_activity` (the community feed) and `training_analytics` (pre-aggregated progress documents). Each document references the relational keys (`technique_id`, `session_id`, `person_id`), so the relational core remains the source of truth for identities and rules.

# References

[1] A. Silberschatz, H. F. Korth, S. Sudarshan, *Database System Concepts*, 7th ed., McGraw-Hill, 2019 (Ch. 6, E-R model).
[2] Introduction to Databases 2026/27, lecture T4, *ER Model* (course slides).
[3] draw.io (JGraph Ltd.), https://www.drawio.com · Pandoc, https://pandoc.org.

```{=latex}
\begin{landscape}
\begin{figure}[p]
\centering
\includegraphics[width=\linewidth,height=0.93\textheight,keepaspectratio]{er.pdf}
\caption{Conceptual ER model of MyKungFuAcademy (vector figure, zoomable; editable source \texttt{er/model.drawio}).}
\end{figure}
\end{landscape}
```

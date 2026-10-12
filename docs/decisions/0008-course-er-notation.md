# 0008: Align the ER model with the course notation (lecture T4, Modeling)
- Status: accepted (supersedes 0006 and the notation item of 0001)
- Delivery: D1
- Date: 2026-10-09

## Context
Lecture T4 (*ER Model*) defines the notation the course expects. It is the Silberschatz et al. notation, *Database System Concepts*, Ch. 6. The first version of the diagram used Chen/Elmasri conventions (circle d/o for specializations, "(min,max)", "partial key"). The slides say explicitly that cardinality limits written on each line are the format to "use in your projects". They also list alternative notations "we will not use".

## Options considered
1. Keep the Chen/Elmasri version and explain it in the report. The professor may read it as not following the course standard.
2. Redraw in the course notation and keep the model's content unchanged.

## Decision
Option 2. The model has the same entity sets, relationship sets and constraints. Only the representation changes:
- Lower-case names for entity sets and relationship sets (`student`, `enrolled_in`), as in the slides.
- An entity set is a rectangle with a light-blue header and attributes listed inside. The primary key is underlined.
- Cardinality limits `l..h` replace `(min,max)`, with the same meaning (`0..*`, `1..1`, `1..*`, `0..1`). A double line also marks total participation (l ≥ 1).
- Weak entity sets: double rectangle, the **discriminator** (the course term for a partial key) with a dashed underline, and an identifying relationship set drawn as a double diamond.
- Specialization: hollow arrows to the higher-level entity set. *person* uses one arrow per subtype (overlapping) and *event* uses a single joined arrow (disjoint). Both are annotated "total".
- Composite attributes (`name` → `first_name`, `last_name`; `emergency_contact` → `contact_name`, `contact_phone`) are shown indented, and the derived attribute `age()` is added to *person*.
- The redundant-attribute rule is kept: no entity set holds another entity set's key. The links are relationship sets.
- The report lists the **primary key of every relationship set** according to the lecture rules: union of keys for M:N, the key of the "many" side for 1:N, the weak entity's key for identifying relationship sets, and {student, rank} for the ternary.
- Diagram scope (relational core only) is unchanged from ADR-0006.

## Consequences
- The diagram and report use the vocabulary the professor will use at the oral exam (entity set, discriminator, completeness constraint, cardinality limits).
- Data types are still written next to the attributes (`name : TYPE`). The slides do not show types, but the D1 brief requires them.
- Aggregation (also in T4) is not used. No relationship set needs to take part in another relationship set.

## Related: ADR-0001, ADR-0003 to 0007, deliveries/D1/er/model.drawio, report §4

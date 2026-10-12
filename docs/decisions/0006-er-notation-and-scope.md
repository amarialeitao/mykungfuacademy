# 0006: ER notation (Chen with (min,max)) and diagram scope (relational core)
- Status: superseded by 0008
- Delivery: D1
- Date: 2026-10-07

## Context
The diagram must show attributes with data types, keys, cardinalities and participation for about 20 entities, and must stay readable. The hybrid architecture also places part of the data in MongoDB (D3).

## Options considered
- Classic Chen with attribute ovals: faithful to the course, but unreadable at this size once data types are added.
- Crow's foot: compact, but ternary relationships and specializations are less natural.
- Chen with (min,max) and attributes listed inside the entity box.

## Decision
- **Notation:** Chen rectangles and diamonds. Every entity-relationship line has a **(min,max)** label at the entity end: how many relationship instances the entity takes part in. min = 0 means partial and min ≥ 1 means total participation. Weak entities and identifying relationships use double borders, and partial keys are dashed-underlined. Specializations use a circle with **d**/**o**, and a double line to the supertype means total. Relationship attributes are shown in a box attached to the diamond. Attributes appear inside the entity box as `name : TYPE`, with **PK** and **PPK** (partial key) marked. A legend is included in the diagram.
- **Scope:** the diagram models the **relational core only**. The planned MongoDB collections are described in the report text and modeled in D3.

## Consequences
- The diagram stays readable and the data types are visible.
- The data types are conceptual choices, refined when mapped in D2.

## Related: ADR-0003 to 0005

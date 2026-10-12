# D1: Exploratory queries

Ten natural-language questions over the conceptual model. Each has an explanatory comment, the entities it crosses and the FRs it supports. They are implemented in SQL in D2 (`deliveries/D2/sql/queries.sql`) with the same Q-numbers.

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

## Implementation hints for D2

| Query | Expected SQL techniques |
|---|---|
| Q1 | CTE with the latest promotion per (student, discipline) (`DISTINCT ON` or `ROW_NUMBER`), join to the next rank, correlated count of attendance; `HAVING` on both thresholds |
| Q2 | `NOT EXISTS` anti-join between *requires* and recent *session_activity* |
| Q3 | `LAG(promoted_on) OVER (PARTITION BY student, discipline ORDER BY rank_order)`; second ranking with `*rank*()` |
| Q4 | Aggregate per class, then `AVG` per (discipline, instructor, level) with `HAVING < 0.5` |
| Q5 | `ROW_NUMBER()` to pick the two latest evaluations, self-join or `LAG` on the normalized score |
| Q6 | `generate_series` or date filter over 4 weeks; `*rank*() OVER (PARTITION BY instructor)` |
| Q7 | `DENSE_RANK() OVER (PARTITION BY discipline ORDER BY points DESC)`, filter ≤ 10 |
| Q8 | `LATERAL` subquery for the last promotion before the competition date |
| Q9 | `EXISTS` on recent attendance plus `SUM` of overdue payments |
| Q10 | `FILTER (WHERE ...)` aggregates for on-time, late and abandoned |

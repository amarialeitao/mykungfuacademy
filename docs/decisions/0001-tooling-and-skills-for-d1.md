# 0001: Tooling and skills for D1
- Status: accepted
- Delivery: D1
- Date: 2026-10-07

## Context
D1 is requirements analysis and conceptual (ER) modeling. CLAUDE.md §3 asks for a search of available skills and plugins for ER modeling, normalization, requirements, SQL, MongoDB, benchmarking and visualization before work starts.

## Options considered
- **Data plugin** (Anthropic; already enabled): SQL authoring, query writing, validation and charts. Helps D2 and D4, and the D1 exploratory questions.
- **MongoDB (Self-Managed MCP) plugin**: schema design and query optimization for MongoDB Community. Belongs to D3 and D4.
- Cloud SQL, Azure SQL, VillageSQL, NeoSQL plugins: target other DBMSs or cloud services. Rejected.
- **ER modeling, normalization, requirements engineering or draw.io skills**: none found.

## Decision
- D1 uses no modeling skill, because none exists. The discipline is applied manually: Chen notation with (min,max) constraints (Elmasri & Navathe), the requirement-writing rules in CLAUDE.md §11, and a self-review against the D1 grading table.
- The Data plugin's `sql-queries` guidance is used only to check that every exploratory question can later be written as SQL in D2.
- The MongoDB plugin is postponed to D3 and will be installed only with Maria's approval.
- Tools: draw.io (diagram; export done by Maria in draw.io Desktop), Pandoc + XeLaTeX (report PDF), Git/GitHub.

## Consequences
- No skill shortcuts for modeling. Every modeling choice is recorded in its own ADR so it can be defended at the oral exam.
- AI assistance disclosure is not required by the course (confirmed by Maria).

## Related: ADR-0002 to 0007

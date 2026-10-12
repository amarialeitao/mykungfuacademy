# MyKungFuAcademy

Hybrid database system for a martial-arts academy: a PostgreSQL relational core for academy operations and student progression, and MongoDB for flexible data such as instructional content, wearable telemetry and training analytics.

Course project for Introduction to Database Systems 2026/27, Group 12 (Maria Leitão).

## Deliveries and branches

The project is delivered in four phases. Each phase has its own branch, created from the branch of the previous phase:

| Branch | Content |
|---|---|
| `master` | This README only, until the final phase |
| `IBD2627_D1_Group12` | D1: requirements analysis and conceptual (ER) model |
| `IBD2627_D2_Group12` | D2: relational implementation in PostgreSQL |
| `IBD2627_D3_Group12` | D3: MongoDB integration, migration and sync |
| `IBD2627_D4_Group12` | D4: optimization, indexing and benchmarks |
| `IBD2627_Final_Group12` | Final clean-up, merged into `master` at the end |

The exact state submitted for each phase is tagged (`D1-submitted`, `D2-submitted`, and so on).

## Repository structure

```
deliveries/            one folder per phase, with everything that is graded
  D1/
    er/                ER diagram: model.drawio (editable) and model.png (export)
    report/            report.md (source), report.pdf (built), er.pdf (diagram used in the PDF)
    queries.md         the 10 exploratory questions, with notes for the D2 SQL
docs/                  project documentation, not submitted
  domain.md            description of the miniworld: scope, assumptions, business rules, glossary
  decisions/           design decisions, one file per decision (NNNN-title.md)
  study-guide/         preparation notes for the oral exam of each phase
  backlog.md           ideas left for later phases
  references.md        books, course material and tools used
tools/
  report/              shared Pandoc header and build.sh to turn report.md into report.pdf
  package.sh           builds the submission zip of a phase
```

Folders for later phases (SQL scripts, MongoDB scripts, data generator, benchmarks) are added when each phase starts. `dist/` holds the generated submission zips and is not versioned.

## Building a delivery

Requirements: Pandoc and a LaTeX distribution with XeLaTeX.

```bash
tools/report/build.sh D1      # deliveries/D1/report/report.md -> report.pdf (prints the page count)
tools/package.sh D1           # creates dist/IBD2627_D1_Group12.zip with the files the brief requires
```

The ER diagram is edited in draw.io. After changing `model.drawio`, export it again to `deliveries/D1/er/model.png` and `deliveries/D1/report/er.pdf` before building the report.

## Conventions

- Everything in the repository is written in English.
- Commit messages follow the conventional format, for example `feat(d2): add belt promotion trigger` or `docs(d1): update report`.
- Every non-trivial design choice is recorded in `docs/decisions/`.

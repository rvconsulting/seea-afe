# Deliverable 1 Implementation Plan

## Overview

Two parallel workstreams: (1) a narrative + visual section added to
`documentation/01_diagnostic_review.qmd`, and (2) a new Dashboard section
in the Quarto website presenting country-level SEEA implementation profiles.

---

## Workstream 1 — Diagnostic Review Section (`01_diagnostic_review.qmd`)

### Goal
Add a self-contained section after the Introduction that describes the AFE
regional dataset, summarizes implementation status, and visualizes account
coverage across countries.

### Dataset facts (from `afe2025`)
- **26 countries** in the AFE region assessed
- **11 implementing** the SEEA; 15 not yet implementing
- Implementation stages (SDG 15.9.1b): Stage I (3), Stage II (4), Stage III (4)
- **36 accounts** tracked across 3 groups: SEEA Central Framework, SEEA
  Ecosystem Accounts, Thematic Accounts
- **29 compiled accounts** across 11 countries (some countries compile multiple)
- Most compiled accounts: energy PSUTs (5 countries), water PSUTs (5 countries),
  land physical asset accounts (3 countries)
- Most active compilers: South Africa and Uganda (5 accounts each), Ethiopia
  and Kenya (4 each)

### Section outline

**2. Regional Assessment Dataset**

2.1 Data Sources and Scope
- Describe the 2025 Global Assessment dataset, the AFE subset, the 26 countries,
  the 36 SEEA accounts tracked, and what "Compiled" means.
- Note imputed vs. self-reported data.
- Cite SEEA CF and EA frameworks.

2.2 Implementation Status
- Paragraph: share of countries implementing, stage distribution, and what
  SDG 15.9.1b stages mean.
- **Visual A — Stage of Implementation bar/lollipop chart**: countries on y-axis,
  colored by stage (Stage I / II / III / Not implementing), sorted by number of
  compiled accounts. Rendered with `ggplot2`; Word-safe (no interactive elements).

2.3 Account Coverage
- Paragraph: which account groups are most common and why (energy/water PSUTs
  are entry-level accounts, hence widest adoption).
- **Visual B — Heat-map tile plot**: rows = accounts (grouped by Account Group),
  columns = countries (ordered by total compiled accounts), fill = "Compiled"
  (Yes/No). Clean, minimal `ggplot2` tile chart with `facet_grid` for account
  groups. This renders well in both HTML and Word.
- Optional complement: a `gt` summary table showing, per Account Group, the
  number of accounts and the number of countries compiling at least one — useful
  as a Word-friendly alternative or addition.

2.4 Gaps and Opportunities
- Short narrative identifying the biggest gaps (ecosystem accounts, monetary
  accounts, thematic accounts) and flagging high-potential countries for deeper
  analysis in Deliverable 2.

### Implementation notes
- Load data from `outputs/assessment/AFE_assessment_2025.RDS` at the top of
  the document so it is self-contained.
- Use a `#| echo: false` code block for all data prep.
- Use `#| fig-alt` for accessibility.
- Figures should use the project's `styles.css` color palette or a colorblind-
  safe discrete palette (`scale_fill_brewer(palette = "Set2")`).
- The `gt` table should use `as_word()` / `tab_options(latex.use_longtable)`
  guards if needed, but basic `gt` renders fine in both HTML and Word docx.

---

## Workstream 2 — Country Dashboard (`dashboard/index.qmd`)

### Goal
A new top-level Quarto page (type: `dashboard`) with one tab per country,
showing that country's SEEA implementation profile at a glance.

### Site changes required
- Add `dashboard/index.qmd` to the repo.
- Register it in `_quarto.yml` navbar (e.g., label "Dashboard").

### Dashboard layout
- **Page header**: brief explainer (1–2 sentences on SEEA and the AFE region).
- **Tabset**: one tab per country (26 tabs), ordered alphabetically.
  - Tabs labelled with country name.
  - Each tab contains:

| Card | Content |
|---|---|
| **Status** | Implementing SEEA? Stage of implementation. Responding institution. |
| **Account coverage** | Small horizontal bar chart (`ggplot2`) — accounts on y, fill = Compiled (Yes/No), faceted by Account Group. |
| **Summary table** | `gt` table listing compiled accounts (Account Group, Account name) — only "Yes" rows shown. |
| **Notes** | Imputed data flag, website link (if available). |

### Technical approach
- Use `quarto` dashboard format (`format: dashboard`).
- Data loaded once at top of document with `#| context: setup` (or plain setup
  chunk before tabset).
- Tabs generated with `#| output: asis` + `cat()` in a loop, or preferably
  with `purrr::walk` + inline R child chunks using `::: {.panel-tabset}`.
- Keep all visuals static (`ggplot2` / `gt`) for Word compatibility even though
  the dashboard is HTML-first; avoid `plotly` / `DT` unless explicitly requested.
- Country-level data filtered from `afe2025` (loaded from RDS).

### `_quarto.yml` addition
```yaml
- text: "Dashboard"
  href: dashboard/index.qmd
```

---

## File checklist

| File | Action |
|---|---|
| `documentation/01_diagnostic_review.qmd` | Add section 2 (dataset description + 2 visuals) |
| `dashboard/index.qmd` | Create new dashboard page |
| `_quarto.yml` | Register dashboard in navbar |

---

## Suggested implementation order

1. Add data-loading chunk and Section 2 narrative + Visual A (stage chart) to
   `01_diagnostic_review.qmd`.
2. Add Visual B (heat-map) and optional `gt` summary table to same file.
3. Create `dashboard/index.qmd` with tabset structure and per-country cards.
4. Update `_quarto.yml` to register the dashboard.

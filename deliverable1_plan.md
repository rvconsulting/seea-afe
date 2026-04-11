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


## Meeting with client

Client liked @01_diagnostic_review.qmd and noted that they need:

* A better explanation of the stages relating to figure 1, which have been added already. We also explained that we added a new category denoting those that have implemented "something," but it's not SEEA related.
* One big ask that was given to us in the meeting is that we are no longer bound by length. The core of the note can stay at ~15 pages, but we can have an unbound Annex where we show important data that focuses on the last item of the terms of reference for the first product (@00_terms_of_reference.qmd) for each country. Specifically, _6. Propose cross-country and country-specific analyses and stylized facts that can be derived from the available data, that could inform, planning, economic policy and decision-making_. They are keen on data that speaks to impacts on GDP or vs GDP and know if data insights are already useful for their reports (not necessarily for modelling efforts). Pull out useful indicators for policy from the published reports or data, which are illustrative but not overwhelm the reader that wants to use our document as reference when putting together proposals or reports for the World Bank.
* We are also required to hint at answers to (we do not have to implement the answers in this paper, just talk about what projects we could promote down the line to improve upon these things through the partnership between the World Bank and these countries):
  - How can the World Bank prioritize if data is not disaggregated at regional level (especially for water and sanitation projects)?
  - Related to the first item, how can we solve spatial disaggregation? Which investments could improve that if the Bank were to help the countries create projects for institutional strenghtening at statistics institutions. 
  - How can the World Bank support institutionalization (one big problem of SEEA implementation projects is budget continuity and institutional take-up at statistical institutions)?
  - They want more examples of monetary valuation and more specific indicators.

---

## Annex implementation

The Annex "Country-Level Policy Insights from Available Accounts" was added to the end of `01_diagnostic_review.qmd`. Structure per country:

- Accounts are ordered following the SEEA account order in Table 1 (tbl-all-seea-accounts).
- Each entry describes available accounts, extracts specific indicators with numbers, GDP linkages, and points to source tables/figures.
- Where monetary valuation is absent, the physical flows are quantified and valuation pathways identified.

### Countries completed:
- **Ethiopia** (eth): Land accounts (physical + monetary context, 4 SEEA accounts) + Ecosystem services (physical only). Sources: `First Edition Land accounts for Ethiopia_Jan 2026.pdf` + `Ethiopia_EcosystemServicesAccounting_Technical_Report_vers0.2_Dec_2025.pdf`. Citation keys added to `references.bib`.
- **Kenya** (ken): 10 compiled accounts across 5 sectors (water, energy, land, ecosystem, forest). Includes full monetary ecosystem services accounts (livestock KSh 185 bn, sediment retention KSh 24 bn, tourism KSh 38 bn = KSh 247 bn total = 1.8% of GDP in 2018). Sources: 5 DOCX reports converted to plain text via pandoc. Citation keys added to `references.bib`.
- **Madagascar** (mad): 2 compiled accounts (ecosystem extent + condition). Physical-only accounts based on integrated landscape assessment (1992–2020). Key indicators: 35.6% of land area degrading; 3.08 Gt/year soil erosion; 27.2 Mt/year sediment export; 6.25 Gt carbon stock; 1.56 Mt CO₂/year absorption loss (≈ US$59M/year social cost); 81% erosion reduction potential from NBS in priority zones; top 7.5% of territory holds 31% of national carbon stock. Sources: `Madagascar Landacpe Analysis_Technical_Methods_18May2022_final.docx` + `Mad_EcosystemIndex_database_updatedV2.xlsx`. Citation key `vogl_madagascar_2022` added to `references.bib`.

- **Mauritius** (mus): 2 compiled accounts (physical supply/use tables for water + physical asset accounts for water). 5th edition institutional series by Statistics Mauritius (Dec 2024). Key indicators: TRWR 2,874 Mm³ (2022); abstraction 22% of TRWR (no stress); hydropower largest abstractor (431 Mm³, 40.5%); UFW 64.6% and worsening (56.4% in 2013); total water consumption 229 Mm³ (agriculture 89.1%); households receive 197 L/day vs 719 L/day abstracted (difference = leakage). Source: `Water_Yr22_231224.pdf`. Citation key `statsmauritius_water_2024` added to `references.bib`.

- **Rwanda** (rwa): 5 compiled accounts (water physical + **monetary** PSUT, land physical assets, ecosystem condition + physical services). Monetary water productivity = 4,762 Rwf/m³ (2015); agriculture 118 Rwf/m³ vs mining 6,236 Rwf/m³; GDP +25% while water use +10% (relative decoupling 2012-2015); WASAC NRW 41% = US$8.7M loss; soil erosion +54% since 1990 = 158 Mt/yr; baseflow −11%; sediment export +123%; wetland −14,000 ha 2010-2015; land transactions avg 35M Rwf/ha (Kigali 130M). Sources: 3 PDFs + water Excel. Citation keys `nisr_rwanda_water_2019`, `nisr_rwanda_ecosystem_2019`, `nisr_rwanda_land_2018` added.

- **Uganda** (uga): 6 compiled accounts (water physical PSUT, **monetary** timber asset accounts, ecosystem extent, physical + **monetary** ecosystem services, ecosystem asset accounts). Forest cover −60% (4.93 → 1.95 M ha, 1990–2015); monetary wood stock −19% (US$9.1B → US$7.4B); forest land value US$34.9B (2015) despite area loss; sustainable wood supply depleted by ~2025; supply deficit 35 Mt (2015) → 105 Mt (2040); charcoal = 78% of national energy; forestry 4–8% GDP. Water productivity UGX 5,557/m³ consumed (2024, +84% from 2015); distribution losses 34.8%; oil sector abstraction +113.9%. Sources: 1 PDF (forest) + 1 PDF (water 2024). Citation keys `ubos_uganda_forest_2020`, `ubos_uganda_water_2025` added.

- **South Africa** (zaf): 7 compiled accounts (water PSUT + asset + **emission** accounts for SWSAs, energy PSUT, land asset accounts, ecosystem extent, physical ecosystem services). SWSAs = 8.2% of land but supply ~two-thirds of economic activity; 3 SWSAs below 60% natural threshold. Energy: 6,519 PJ natural inputs; coal 72.2% domestic supply; oil 93.1% import dependent. Land: natural stable (+0.8%) but pivots +221%, mines +16%, grassland historically −11.1M ha. Biodiversity tourism = 0.4–0.5% GDP = R27.7B (2019) + 92k jobs. Estuaries: condition 63.7/100; 63% area heavily modified; sawfish extinct; only 4% of estuaries have good fish condition. Sources: 4 PDFs + 2 Excel files. Citation keys `statssa_water_swsa_2023`, `statssa_land_2020`, `statssa_energy_2025`, `statssa_biodiversity_tourism_2024`, `statssa_protected_areas_2021`, `csir_estuaries_2020` added.

- **Zambia** (zmb): 5 compiled accounts (land physical assets, timber PSUT, water PSUT, ecosystem extent, protected areas thematic). Land: trees −1.88M ha (−4.5%, 2018-2023) = 376k ha/yr; crops +960k ha (+36.9%); trees→rangeland 4.9M ha dominant transition; NEDI 1.44%. Water: 19% of territory is wetlands; Bangweulu US$11.7M/year; Lake Kariba <15% capacity 2016+2024; drought national disaster 2023/24. Carbon: NPV loss USD 46M (2018-2023). Fish: +42.4% (178k MT, ZMW 8B = US$423M in 2023). Bush meat: K118M (+158%) = US$4.6M. 40% income from natural resources. Sources: 2 DOCXs + 2 Excels. Citation keys `zambia_nca_compendium_2026`, `zambia_ecosystem_account_2026` added.

### Countries pending:
- DRC (drc) — Annex section not yet written; DRC data extracted via subagent (see below) and incorporated into data gaps section and 02_analytical_results.qmd.

---

## Session 3 — Deliverable 2 Preparation

### Tasks completed:

1. **Common Data Gaps section** (`01_diagnostic_review.qmd`, lines 344–): Completely rewrote and expanded `## Common data gaps and recurring problems`. New section is `## Common Data Gaps and Systemic Recommendations` with six subsections (Data Infrastructure, Classification/Comparability, Monetary Valuation, Spatial Disaggregation, Institutionalization, Thematic Gaps) plus `### Priority Areas for Capacity Development`. Merged and replaced `# Other Assessment Problems and Opportunities` (which was at the wrong hierarchical level). Added DRC citation key `worldbank_drc_forest_2025` to `references.bib`.

2. **Inventory** (`documentation/inventory_for_analytical_results.md`): Created 71-item numbered inventory of named tables, figures, and Excel tabs organized by `country.account_type.item#` format. Covers DRC (6 items), ETH (9), KEN (10), MAD (2), MUS (3), RWA (9), UGA (8), ZAF (19), ZMB (7). Maps flagged as reference-only. No CSVs created.

3. **02_analytical_results.qmd** (`documentation/02_analytical_results.qmd`): Full draft of Deliverable 2 analytical results document with six thematic sections:
   - Energy and Minerals (ASCENT program lens; countries: DRC, ETH, KEN, UGA, ZAF, ZMB)
   - Forests (MBJ indicator lens; countries: DRC, ETH, KEN, UGA, ZMB)
   - Water (contribution to sectors; countries: KEN, MUS, RWA, UGA, ZAF, ZMB)
   - Additional Applications (soil, carbon, biodiversity tourism, fisheries; all countries)
   - Cross-Country Comparisons (charcoal parallel, forest loss, valuation frontier, water productivity)
   - Policy Relevance, Reflections, and Conclusions (combined)
   - Inventory item placeholders inserted as [inventory item: X.X.X about here]
   - ASCENT and MBJ researched online; findings incorporated.

4. **DRC data extracted** via subagent from `P180767_DRC - Forest Ecosystems accounts 2000-20-EN.pdf`:
   - Title: "Democratic Republic of Congo's Forest Ecosystem Accounts and Policy Recommendations: Ecosystem extent, condition, services, and asset accounts 2000-2020"
   - Institution: World Bank Group; Year: August 2025; Project P180767
   - Lead technical team: Dr Jane Turpie (Anchor Environmental Consultants)
   - Forest lost 2000-2020: 11.6M ha; deforestation rate doubled 0.5% → 0.8%/yr
   - Carbon: 55,640 Mt C total (peat soils 1,917 t/ha); ecosystem services US$706B/yr (incl. carbon)
   - Forestry 9% GDP; 94% energy from biomass; 90% informal logging
   - Citation key `worldbank_drc_forest_2025` added to references.bib

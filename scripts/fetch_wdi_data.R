# fetch_wdi_data.R
# Downloads World Development Indicators for the nine AFE countries reviewed in
# the NCA report and saves the results as RDS files under data/wdi/.
# Run this script once; the Quarto document loads the cached files directly.

library(WDI)
library(tidyverse)

# ── Countries and indicators ──────────────────────────────────────────────────
afe_iso3c <- c("COD", "ETH", "KEN", "MDG", "MUS", "RWA", "UGA", "ZAF", "ZMB")

wdi_indicators <- c(
  "NY.GDP.PCAP.CD",    # GDP per capita (current USD)
  "NY.GDP.MKTP.CD",    # GDP (current USD)
  "NV.AGR.TOTL.ZS",   # Agriculture, forestry & fishing, value added (% GDP)
  "SP.RUR.TOTL.ZS",   # Rural population (% of total)
  "SP.URB.TOTL.IN.ZS", # Urban population (% of total)
  "EN.GHG.CO2.PC.CE.AR5", # CO2 emissions excl. LULUCF per capita (t CO2e, AR5)
  "SI.POV.DDAY",      # Poverty headcount at $2.15/day (2017 PPP, % pop)
  "AG.LND.FRST.ZS",   # Forest area (% of land area)
  "SP.POP.TOTL",      # Population, total
  "TX.VAL.AGRI.ZS.UN" # Agricultural raw materials exports (% of merchandise exports)
)

wdi_labels <- c(
  NY.GDP.PCAP.CD    = "GDP per capita (USD)",
  NY.GDP.MKTP.CD    = "GDP (USD)",
  NV.AGR.TOTL.ZS    = "Agriculture value added (% GDP)",
  SP.RUR.TOTL.ZS    = "Rural population (%)",
  SP.URB.TOTL.IN.ZS = "Urban population (%)",
  EN.GHG.CO2.PC.CE.AR5 = "CO2 per capita excl. LULUCF (t CO2e, AR5)",
  SI.POV.DDAY       = "Poverty headcount ($2.15/day, %)",
  AG.LND.FRST.ZS    = "Forest area (% of land)",
  SP.POP.TOTL       = "Population",
  TX.VAL.AGRI.ZS.UN = "Agri. exports (% of merchandise)"
)

country_names <- c(
  COD = "DR Congo", ETH = "Ethiopia", KEN = "Kenya",
  MDG = "Madagascar", MUS = "Mauritius", RWA = "Rwanda",
  UGA = "Uganda", ZAF = "South Africa", ZMB = "Zambia"
)

# ── Fetch ─────────────────────────────────────────────────────────────────────
message("Fetching WDI data...")

wdi_raw <- WDI(
  country   = afe_iso3c,
  indicator = wdi_indicators,
  start     = 2010,
  end       = 2023,
  extra     = TRUE
)

# ── Derive wdi_latest (one row per country-indicator, most recent non-NA) ─────
# Use only indicators that were actually returned by the API
downloaded_indicators <- intersect(wdi_indicators, names(wdi_raw))
missing_indicators    <- setdiff(wdi_indicators, names(wdi_raw))
if (length(missing_indicators) > 0) {
  message("Note: the following indicators were not available and are skipped: ",
          paste(missing_indicators, collapse = ", "))
}

wdi_latest <- wdi_raw |>
  pivot_longer(
    cols      = all_of(downloaded_indicators),
    names_to  = "indicator",
    values_to = "value"
  ) |>
  filter(!is.na(value)) |>
  group_by(iso3c, country, indicator) |>
  slice_max(year, n = 1) |>
  ungroup() |>
  mutate(
    label         = wdi_labels[indicator],
    country_label = country_names[iso3c]
  )

# ── Save ──────────────────────────────────────────────────────────────────────
dir.create("data/wdi", showWarnings = FALSE)

saveRDS(wdi_raw,    "data/wdi/wdi_raw.RDS")
saveRDS(wdi_latest, "data/wdi/wdi_latest.RDS")

message("Saved data/wdi/wdi_raw.RDS and data/wdi/wdi_latest.RDS")

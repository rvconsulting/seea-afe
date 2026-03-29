library(tidyverse)
library(readxl)
library(openxlsx)

# Read Assessment Data
ga2025 <- read_excel(
  "data/assessment/global_assessment_2025.xlsx",
  sheet = "seea_ga_db_2025"
)

# Pivot Longer for Convenience
ga2025long <- ga2025 |>
  pivot_longer(
    c(13:length(colnames(ga2025))),
    names_to = c("Account Group", "Account"),
    names_sep = "_",
    values_to = "Compiled"
  ) |>
  mutate(
    Compiled = case_when(
      tolower(Compiled) == "x" ~ "Yes",
      .default = "No"
    )
  )

afe2025 <- ga2025long |>
  filter(tolower(AFE) == "yes") |>
  mutate(
    quality_of_inputs = "",
    is_dataset = "",
    geographic_coverage = "",
    notes = ""
  )

# Extract the list of all possible accounts
seea_accounts <- read_excel(
  "data/assessment/global_assessment_2025.xlsx",
  sheet = "Cover",
  range = "B23:C59"
) |>
  fill(`Thematic category`, .direction = "down")

# Compilation summary table

# Ethiopia data

es_condition_region <- read_excel(
  "data/assessment/eth/eth_ecosystem_services_2025.xlsx",
  sheet = "ServPotSupply_byRegion",
  range = "B2:Q15"
) |>
  rename(
    `Ecosystem Service / Unit` = Regions
  ) |>
  pivot_longer(
    cols = 3:16,
    names_to = "Region",
    values_to = "Value"
  )

es_condition_basin <- read_excel(
  "data/assessment/eth/eth_ecosystem_services_2025.xlsx",
  sheet = "ServPotSupply_byRiverBasin",
  range = "A2:L15"
) |>
  rename(
    `Ecosystem Service / Unit` = Watershed
  ) |>
  pivot_longer(
    cols = 3:12,
    names_to = "Basin",
    values_to = "Value"
  )

# ETH Save to disc
write.xlsx(
  es_condition_basin,
  "data/assessment/eth/es_condition_region.xlsx",
  overwrite = T
)
write.xlsx(
  es_condition_basin,
  "data/assessment/eth/es_condition_basin.xlsx",
  overwrite = T
)
saveRDS(
  es_condition_basin,
  "data/assessment/eth/es_condition_region.RDS",
)
saveRDS(
  es_condition_basin,
  "data/assessment/eth/es_condition_basin.RDS"
)

# Various saves
saveRDS(
  seea_accounts,
  "outputs/assessment/seea_accounts.RDS"
)
saveRDS(
  afe2025,
  "outputs/assessment/AFE_assessment_2025.RDS"
)

write.xlsx(
  afe2025,
  "outputs/assessment/AFE_assessment_2025.xlsx",
  overwrite = T
)

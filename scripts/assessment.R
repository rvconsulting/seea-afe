library(tidyverse)
library(openxlsx)

ga2025 <- readxl::read_excel(
  "data/assessment/global_assessment_2025.xlsx",
  sheet = "seea_ga_db_2025"
)

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

write.xlsx(
  afe2025,
  "outputs/AFE_assessment_2025.xlsx",
  overwrite = T
)

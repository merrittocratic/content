library(tidyverse)
library(gt)

q1q4 <- tibble(
  game      = c("G1", "G2", "G3", "G4", "G5"),
  q1_margin = c("SAS +8", "SAS +9", "SAS +11", "SAS +19", "SAS +10"),
  peak_lead = c("+14", "+12", "+12", "+29", "+16"),
  q4_margin = c("NYK +10", "SAS +8", "SAS +3", "NYK +16", "NYK +11"),
  winner    = c("NYK +10", "NYK +1", "SAS +4", "NYK +1", "NYK +4")
)

sas_bg   <- "#eeeeee"
sas_text <- "#333333"
nyk_bg   <- "#fff3e0"
nyk_text <- "#7a3200"

q1q4 |>
  gt() |>
  tab_header(
    title    = md("**Every Q1, Every Q4 -- 2026 NBA Finals**"),
    subtitle = "San Antonio led Q1 in all five games. New York led Q4 in three."
  ) |>
  cols_label(
    game      = "Game",
    q1_margin = "Q1 Margin",
    peak_lead = "SAS Peak Lead",
    q4_margin = "Q4 Margin",
    winner    = "Winner"
  ) |>
  cols_align(align = "center", columns = c(q1_margin, peak_lead, q4_margin, winner)) |>
  cols_align(align = "left", columns = game) |>
  cols_width(
    game      ~ px(60),
    q1_margin ~ px(110),
    peak_lead ~ px(130),
    q4_margin ~ px(110),
    winner    ~ px(100)
  ) |>
  tab_style(
    style = cell_fill(color = "#f9f9f9"),
    locations = cells_body(rows = c(1, 3, 5))
  ) |>
  tab_style(
    style = cell_text(weight = "bold"),
    locations = cells_body(columns = game)
  ) |>
  # Q1 column: SAS won every quarter
  tab_style(
    style = list(cell_fill(color = sas_bg), cell_text(color = sas_text, weight = "bold")),
    locations = cells_body(columns = q1_margin)
  ) |>
  # Q4 column: NYK positive (G1, G4, G5)
  tab_style(
    style = list(cell_fill(color = nyk_bg), cell_text(color = nyk_text, weight = "bold")),
    locations = cells_body(columns = q4_margin, rows = c(1, 4, 5))
  ) |>
  # Q4 column: SAS positive (G2, G3)
  tab_style(
    style = list(cell_fill(color = sas_bg), cell_text(color = sas_text, weight = "bold")),
    locations = cells_body(columns = q4_margin, rows = c(2, 3))
  ) |>
  # Winner: NYK (G1, G2, G4, G5)
  tab_style(
    style = list(cell_fill(color = nyk_bg), cell_text(color = nyk_text, weight = "bold")),
    locations = cells_body(columns = winner, rows = c(1, 2, 4, 5))
  ) |>
  # Winner: SAS (G3)
  tab_style(
    style = list(cell_fill(color = sas_bg), cell_text(color = sas_text, weight = "bold")),
    locations = cells_body(columns = winner, rows = 3)
  ) |>
  # Highlight G4 peak lead (+29 is the outlier the article mentions)
  tab_style(
    style = cell_text(weight = "bold", size = px(13)),
    locations = cells_body(columns = peak_lead, rows = 4)
  ) |>
  tab_options(
    column_labels.background.color    = "#1a1a2e",
    column_labels.font.weight         = "bold",
    column_labels.border.top.color    = "#1a1a2e",
    column_labels.border.bottom.color = "#1a1a2e",
    heading.title.font.size           = px(17),
    heading.subtitle.font.size        = px(12),
    heading.align                     = "left",
    table.font.size                   = px(12),
    table.font.names                  = "Georgia",
    table.border.top.color            = "#1a1a2e",
    table.border.bottom.color         = "#1a1a2e",
    source_notes.font.size            = px(10),
    data_row.padding                  = px(10)
  ) |>
  tab_style(
    style = cell_text(color = "white", weight = "bold"),
    locations = cells_column_labels(everything())
  ) |>
  tab_source_note(
    source_note = "Merrittocracy | themerrittocracy.substack.com"
  ) |>
  gtsave("graphics/q1_q4_breakdown.png", expand = 10)

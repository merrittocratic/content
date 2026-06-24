library(tidyverse)
library(gt)

wave <- tibble(
  metric = c("Cut rate", "Avg strokes (36 holes)", "Avg SG per player"),
  am     = c("42.3%", "+5.79", "baseline"),
  pm     = c("50.0%", "+5.19", "+0.45")
)

wave |>
  gt() |>
  tab_header(
    title    = md("**Thursday Wave Split**"),
    subtitle = "PM starters had the advantage across every meaningful stat"
  ) |>
  cols_label(
    metric = "",
    am     = "AM WAVE",
    pm     = "PM WAVE"
  ) |>
  tab_style(
    style = cell_text(weight = "bold"),
    locations = cells_body(columns = metric)
  ) |>
  tab_style(
    style = cell_text(color = "#15803d", weight = "bold"),
    locations = cells_body(columns = pm)
  ) |>
  cols_align(align = "left",  columns = metric) |>
  cols_align(align = "right", columns = c(am, pm)) |>
  cols_width(
    metric ~ px(200),
    am     ~ px(120),
    pm     ~ px(120)
  ) |>
  tab_options(
    table.border.top.style            = "none",
    table.border.bottom.style         = "none",
    heading.border.bottom.style       = "none",
    column_labels.background.color    = "white",
    column_labels.font.weight         = "normal",
    column_labels.border.top.style    = "none",
    column_labels.border.bottom.color = "#cccccc",
    column_labels.border.bottom.width = px(1),
    table_body.hlines.color           = "#eeeeee",
    table_body.hlines.style           = "solid",
    table_body.border.bottom.color    = "#cccccc",
    heading.title.font.size           = px(18),
    heading.subtitle.font.size        = px(12),
    heading.align                     = "left",
    table.font.size                   = px(13),
    table.font.names                  = "Georgia",
    source_notes.font.size            = px(10),
    source_notes.border.lr.style      = "none",
    data_row.padding                  = px(12)
  ) |>
  tab_style(
    style = cell_text(color = "#888888", size = px(11)),
    locations = cells_column_labels(everything())
  ) |>
  tab_source_note(
    source_note = "Shadow Leaderboard model | Shinnecock Hills R1-R2 | Cut = made-cut rate by wave"
  ) |>
  gtsave("graphics/us_open_wave_split_table.png", expand = 10)

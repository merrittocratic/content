library(tidyverse)
library(gt)

harper <- tibble(
  game     = c("G1", "G2", "G3", "G4", "G5", "Avg"),
  pts      = c("16", "15", "13", "21", "25", "18.0"),
  fg_pct   = c("60%", "50%", "28%", "67%", "53%", "47%"),
  three_pt = c("1/4", "0/3", "1/8", "3/6", "2/4", "28%"),
  reb      = c("8", "6", "9", "4", "5", "6.4"),
  ast      = c("1", "3", "4", "3", "4", "3.0"),
  context  = c("Loss", "Loss by 1", "Spurs win", "Loss by 1", "Loss by 4", "")
)

loss_bg   <- "#fde8e8"
loss_text <- "#9b2226"
win_bg    <- "#e6f4ea"
win_text  <- "#276221"

harper |>
  gt() |>
  tab_header(
    title    = md("**Dylan Harper -- 2026 NBA Finals**"),
    subtitle = "16, 15, 13, 21, 25 -- the trajectory mattered more than the average"
  ) |>
  cols_label(
    game     = "Game",
    pts      = "Pts",
    fg_pct   = "FG%",
    three_pt = "3PT",
    reb      = "Reb",
    ast      = "Ast",
    context  = "Context"
  ) |>
  cols_align(align = "center", columns = c(pts, fg_pct, three_pt, reb, ast, context)) |>
  cols_align(align = "left", columns = game) |>
  cols_width(
    game     ~ px(55),
    pts      ~ px(55),
    fg_pct   ~ px(60),
    three_pt ~ px(65),
    reb      ~ px(55),
    ast      ~ px(55),
    context  ~ px(110)
  ) |>
  tab_style(
    style = cell_fill(color = "#f9f9f9"),
    locations = cells_body(rows = c(1, 3, 5))
  ) |>
  tab_style(
    style = cell_text(weight = "bold"),
    locations = cells_body(columns = game)
  ) |>
  # Context: Spurs losses
  tab_style(
    style = list(cell_fill(color = loss_bg), cell_text(color = loss_text, weight = "bold")),
    locations = cells_body(columns = context, rows = c(1, 2, 4, 5))
  ) |>
  # Context: Spurs win
  tab_style(
    style = list(cell_fill(color = win_bg), cell_text(color = win_text, weight = "bold")),
    locations = cells_body(columns = context, rows = 3)
  ) |>
  # G3 FG% (28%) was the worst game -- highlight it
  tab_style(
    style = cell_text(color = loss_text, weight = "bold"),
    locations = cells_body(columns = fg_pct, rows = 3)
  ) |>
  # G5 pts (25) was the peak -- highlight it
  tab_style(
    style = cell_text(weight = "bold", size = px(13)),
    locations = cells_body(columns = pts, rows = 5)
  ) |>
  # Avg row: bold everything, top border to separate
  tab_style(
    style = list(
      cell_text(weight = "bold"),
      cell_fill(color = "#f0f0f0")
    ),
    locations = cells_body(rows = 6)
  ) |>
  tab_style(
    style = cell_borders(sides = "top", color = "#1a1a2e", weight = px(2)),
    locations = cells_body(rows = 6)
  ) |>
  tab_footnote(
    footnote = "Avg row 3PT column shows percentage (7-of-25 across series).",
    locations = cells_body(columns = three_pt, rows = 6)
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
    footnotes.font.size               = px(9),
    data_row.padding                  = px(10)
  ) |>
  tab_style(
    style = cell_text(color = "white", weight = "bold"),
    locations = cells_column_labels(everything())
  ) |>
  tab_source_note(
    source_note = "Merrittocracy | themerrittocracy.substack.com"
  ) |>
  gtsave("graphics/harper_finals_line.png", expand = 10)

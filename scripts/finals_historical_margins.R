library(tidyverse)
library(gt)

margins <- tibble(
  year   = c(2014, 2016, 2017, 2019, 2020, 2023, 2026),
  team   = c("Spurs", "Warriors", "Warriors", "Raptors", "Lakers", "Nuggets", "Knicks"),
  g1     = c("+15", "+15", "+22", "+9",  "+18", "+6",  "+10"),
  g2     = c("-2",  "+33", "+19", "-5",  "-2",  "-3",  "+1"),
  g3     = c("+19", "-30", "-21", "+14", "+11", "+15", "-4"),
  g4     = c("+21", "+11", "+5",  "+13", "+6",  "+13", "+1"),
  avg    = c(13.3,  7.3,   6.3,   7.8,   8.3,   7.8,   2.4),
  result = c("Won 4-1", "LOST", "Won 4-1", "Won 4-2", "Won 4-2", "Won 4-1", "Won 4-1")
)

loss_bg    <- "#fde8e8"
loss_text  <- "#9b2226"
win_bg     <- "#e6f4ea"
win_text   <- "#276221"
knicks_bg  <- "#fff8e1"
knicks_acc <- "#7a4f00"

margins |>
  gt() |>
  tab_header(
    title    = md("**3-1 Finals Leads Since 2014**"),
    subtitle = "Game-by-game margins and series average for teams that took a 3-1 lead"
  ) |>
  cols_label(
    year   = "Year",
    team   = "Team",
    g1     = "G1",
    g2     = "G2",
    g3     = "G3",
    g4     = "G4",
    avg    = "Avg",
    result = "Result"
  ) |>
  cols_align(align = "center", columns = c(g1, g2, g3, g4, avg, result)) |>
  cols_align(align = "left", columns = c(year, team)) |>
  cols_width(
    year   ~ px(55),
    team   ~ px(90),
    g1     ~ px(50),
    g2     ~ px(50),
    g3     ~ px(50),
    g4     ~ px(50),
    avg    ~ px(60),
    result ~ px(90)
  ) |>
  fmt_number(columns = avg, decimals = 1) |>
  tab_style(
    style = cell_fill(color = "#f9f9f9"),
    locations = cells_body(rows = c(1, 3, 5, 7))
  ) |>
  tab_style(
    style = cell_text(weight = "bold"),
    locations = cells_body(columns = c(year, team))
  ) |>
  # 2016 Warriors loss row
  tab_style(
    style = list(cell_fill(color = loss_bg), cell_text(color = loss_text)),
    locations = cells_body(rows = 2)
  ) |>
  # 2026 Knicks row — the outlier that won
  tab_style(
    style = cell_fill(color = knicks_bg),
    locations = cells_body(rows = 7)
  ) |>
  tab_style(
    style = cell_text(weight = "bold", color = knicks_acc),
    locations = cells_body(columns = avg, rows = 7)
  ) |>
  # Result column: Won
  tab_style(
    style = list(cell_fill(color = win_bg), cell_text(color = win_text, weight = "bold")),
    locations = cells_body(columns = result, rows = result != "LOST")
  ) |>
  # Result column: LOST
  tab_style(
    style = list(cell_fill(color = loss_bg), cell_text(color = loss_text, weight = "bold")),
    locations = cells_body(columns = result, rows = result == "LOST")
  ) |>
  tab_footnote(
    footnote = "2026 avg includes all five games. All other averages are through Game 4.",
    locations = cells_column_labels(avg)
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
  gtsave("graphics/finals_historical_margins.png", expand = 10)

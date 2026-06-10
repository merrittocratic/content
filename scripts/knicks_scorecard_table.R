library(tidyverse)
library(gt)
library(gtExtras)

# --- Data ---
scorecard <- tibble(
  prediction = c(
    "Castle ≤17 pts = Spurs win",
    "KAT 5+ assists = Knicks win",
    "KAT foul trouble = Spurs Win",
    "Harper healthy",
    "Wemby per-36 scoring dip"
  ),
  game1 = c(
    "Castle: 17 pts\nSpurs lost",
    "KAT: 4 ast\nKnicks won",
    "Did not materialize",
    "Harper: 16 pts\nHealthy",
    "6-of-21 from field\n\"I was bad tonight\""
  ),
  game2 = c(
    "Castle: 14 pts, 5-14 FG\n4 TOs — Spurs lost",
    "KAT: 4 ast\nKnicks won",
    "4th foul with 6:00 left\nin Q3 — KAT played through it",
    "Harper: 15 pts\nHealthy",
    "11-of-21, 22 pts in 2nd half\nTurnover ended it"
  ),
  verdict = c(
    "MISS",
    "MISS",
    "PARTIAL",
    "HIT",
    "PARTIAL"
  )
)

# --- Color palette ---
# Verdict text and background colors
miss_bg   <- "#fde8e8"
miss_text <- "#9b2226"
hit_bg    <- "#e6f4ea"
hit_text  <- "#276221"
part_bg   <- "#fef3cd"
part_text <- "#7a5000"

# --- Build table ---
scorecard |>
  gt() |>
  tab_header(
    title    = md("**The Preview's Scorecard**"),
    subtitle = "Games 1 & 2 — Knicks vs. Spurs NBA Finals"
  ) |>
  cols_label(
    prediction = "Prediction",
    game1      = "Game 1",
    game2      = "Game 2",
    verdict    = "Verdict"
  ) |>
  cols_width(
    prediction ~ px(200),
    game1      ~ px(175),
    game2      ~ px(195),
    verdict    ~ px(100)
  ) |>
  fmt_markdown(columns = everything()) |>
  # Verdict cell styling — MISS
  tab_style(
    style = list(
      cell_fill(color = miss_bg),
      cell_text(color = miss_text, weight = "bold", align = "center")
    ),
    locations = cells_body(columns = verdict, rows = verdict == "MISS")
  ) |>
  # Verdict cell styling — HIT
  tab_style(
    style = list(
      cell_fill(color = hit_bg),
      cell_text(color = hit_text, weight = "bold", align = "center")
    ),
    locations = cells_body(columns = verdict, rows = verdict == "HIT")
  ) |>
  # Verdict cell styling — PARTIAL
  tab_style(
    style = list(
      cell_fill(color = part_bg),
      cell_text(color = part_text, weight = "bold", align = "center")
    ),
    locations = cells_body(columns = verdict, rows = verdict == "PARTIAL")
  ) |>
  # Prediction column — bold
  tab_style(
    style = cell_text(weight = "bold"),
    locations = cells_body(columns = prediction)
  ) |>
  # Alternating row shading for readability
  tab_style(
    style = cell_fill(color = "#f9f9f9"),
    locations = cells_body(rows = c(1, 3, 5))
  ) |>
  # Column header styling
  tab_options(
    column_labels.background.color  = "#1a1a2e",
    column_labels.font.weight       = "bold",
    column_labels.border.top.color  = "#1a1a2e",
    column_labels.border.bottom.color = "#1a1a2e",
    heading.title.font.size         = px(17),
    heading.subtitle.font.size      = px(12),
    heading.align                   = "left",
    table.font.size                 = px(12),
    table.font.names                = "Georgia",
    table.border.top.color          = "#1a1a2e",
    table.border.bottom.color       = "#1a1a2e",
    source_notes.font.size          = px(10),
    data_row.padding                = px(10)
  ) |>
  tab_style(
  style = cell_text(color = "white", weight = "bold"),
  locations = cells_column_labels(everything())
  ) |>
  tab_source_note(
    source_note = "Merrittocracy | themerrittocracy.substack.com"
  ) |>
  gtsave("graphics/g1_g2_scorecard.png", expand = 10)

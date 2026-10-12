# manning_table.R
# Candidate 5 for "Is This The Real Life?" (week6_cfb_wrapup), section
# "Will The Real Texas Please Stand Up?": Arch Manning's two box scores vs.
# his EPA per dropback -- the raw line and the efficiency line disagree.
# Data: Steve's rerun packet (CFBD box scores + cfbfastR EPA per dropback,
# garbage time excluded, corrected 2026 play order).
# Output: graphics/week6_cfb_wrapup/candidate_5.png
# Run from the repo root: Rscript graphics/week6_cfb_wrapup/manning_table.R

library(gt)
library(gtExtras)
library(dplyr)
library(tibble)

# --- Data -------------------------------------------------------------------

manning <- tibble::tribble(
  ~game,                ~comp, ~yds, ~td, ~int, ~ypa, ~epa_db,  ~wk_rank,
  "vs. Ohio State (W)",  23,   195,   1,    1,   5.3,  0.085,   "85th of 225",
  "vs. Oklahoma (L)",    19,   260,   3,    2,   8.4, -0.130,   "131st of 199"
)

osu_row <- which(manning$game == "vs. Ohio State (W)")
ou_row  <- which(manning$game == "vs. Oklahoma (L)")

# --- Build table ------------------------------------------------------------

tbl <- manning |>
  gt() |>

  cols_label(
    game     = "",
    comp     = "Comp",
    yds      = "Yds",
    td       = "TD",
    int      = "INT",
    ypa      = "Yds/att",
    epa_db   = "EPA per dropback",
    wk_rank  = "Rank that week"
  ) |>

  tab_spanner(label = "Box score",  columns = c(comp, yds, td, int, ypa)) |>
  tab_spanner(label = "Efficiency", columns = c(epa_db, wk_rank)) |>

  fmt_number(columns = ypa, decimals = 1) |>
  fmt_number(columns = epa_db, decimals = 3, force_sign = TRUE) |>

  tab_header(
    title    = md("**Arch Manning's Box Scores Tell the Story Backwards**"),
    subtitle = md("The game that looks better on paper was the worse passing day")
  ) |>

  tab_footnote(
    footnote  = "Includes Peyton Bowen's 42-yard pick-six, worth -6.9 EPA on one throw, and the interception at the Oklahoma 39 with 0:24 left that set up the winning field goal.",
    locations = cells_body(columns = int, rows = ou_row)
  ) |>

  tab_source_note(
    source_note = md("**TheMerrittocracy** · Box scores via CFBD; EPA per dropback via cfbfastR, garbage time excluded, corrected 2026 play order. Season: Manning ranks 118th of 223 QBs (+0.002).")
  ) |>

  tab_options(
    table.font.size                    = px(14),
    heading.title.font.size            = px(18),
    heading.subtitle.font.size         = px(12),
    column_labels.font.size            = px(12),
    table.width                        = pct(100),
    data_row.padding                   = px(10),
    heading.padding                    = px(8),
    source_notes.font.size             = px(10),
    footnotes.font.size                = px(10),
    table.border.top.color             = "#222222",
    heading.border.bottom.color        = "#222222",
    column_labels.border.bottom.color  = "#666666",
    table_body.border.bottom.color     = "#222222"
  ) |>

  tab_style(
    style     = cell_text(weight = "bold"),
    locations = list(cells_column_labels(), cells_column_spanners())
  ) |>

  tab_style(
    style     = cell_text(weight = "bold"),
    locations = cells_body(columns = game)
  ) |>

  # -- Oklahoma: the box-score numbers that look better ----------------------
  tab_style(
    style     = list(cell_fill(color = "#FFF8E1"), cell_text(weight = "bold")),
    locations = cells_body(columns = c(yds, td, ypa), rows = ou_row)
  ) |>

  # -- Efficiency: green for the good day, red for the bad one --------------
  tab_style(
    style     = list(cell_fill(color = "#E8F5E9"), cell_text(weight = "bold", color = "#2E7D32")),
    locations = cells_body(columns = c(epa_db, wk_rank), rows = osu_row)
  ) |>
  tab_style(
    style     = list(cell_fill(color = "#FFEBEE"), cell_text(weight = "bold", color = "#C62828")),
    locations = cells_body(columns = c(epa_db, wk_rank), rows = ou_row)
  ) |>

  cols_align(align = "center", columns = c(comp, yds, td, int, ypa, epa_db, wk_rank)) |>
  cols_align(align = "left",   columns = game) |>

  cols_width(
    game    ~ px(170),
    comp    ~ px(60),
    yds     ~ px(60),
    td      ~ px(50),
    int     ~ px(50),
    ypa     ~ px(70),
    epa_db  ~ px(120),
    wk_rank ~ px(120)
  )

# --- Save as PNG ------------------------------------------------------------

out_dir <- "graphics/week6_cfb_wrapup"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

gtsave(tbl, filename = file.path(out_dir, "candidate_5.png"), vwidth = 760)

cat("wrote", file.path(out_dir, "candidate_5.png"), "\n")

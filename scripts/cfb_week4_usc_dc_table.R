# cfb_week4_usc_dc_table.R
# USC defensive PPA by season and coordinator for the CFB Week 4 "Borrowed Time" post
# Output: graphics/cfb_week4_usc_dc_table.png
#
# Packages: gt, gtExtras, dplyr, tibble

library(gt)
library(gtExtras)
library(dplyr)
library(tibble)

# --- Data -------------------------------------------------------------------

usc_def <- tibble::tribble(
  ~season, ~dc,              ~def_ppa, ~rank,
  "2022",  "Alex Grinch",    0.177,    111L,
  "2023",  "Alex Grinch",    0.186,    110L,
  "2024",  "D'Anton Lynn",   0.090,    71L,
  "2025",  "D'Anton Lynn",   0.082,    66L,
  "2026",  "Gary Patterson", 0.191,    119L
)

bad_rows  <- which(usc_def$rank > 100)
good_rows <- which(usc_def$dc == "D'Anton Lynn")
row_2023  <- which(usc_def$season == "2023")
row_2026  <- which(usc_def$season == "2026")

# --- Build table ------------------------------------------------------------

tbl <- usc_def |>
  gt() |>

  cols_label(
    season  = "Season",
    dc      = "Defensive coordinator",
    def_ppa = "Def PPA",
    rank    = "FBS rank"
  ) |>

  tab_header(
    title    = md("**New Headset, Same Defense**"),
    subtitle = md("USC predicted points added allowed per play. Higher is worse.")
  ) |>

  fmt_number(columns = def_ppa, decimals = 3) |>

  tab_footnote(
    footnote  = "Grinch was fired in November 2023.",
    locations = cells_body(columns = season, rows = row_2023)
  ) |>
  tab_footnote(
    footnote  = "Through five games; three against Group of 5 opponents.",
    locations = cells_body(columns = season, rows = row_2026)
  ) |>

  tab_source_note(
    source_note = md("**TheMerrittocracy** · Data via cfbfastR and the College Football Data API")
  ) |>

  tab_options(
    table.font.size                    = px(13),
    heading.title.font.size            = px(18),
    heading.subtitle.font.size         = px(12),
    column_labels.font.size            = px(12),
    table.width                        = pct(100),
    data_row.padding                   = px(7),
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
    locations = cells_column_labels()
  ) |>

  # -- Grinch and Patterson years: bottom-tier defense -----------------------
  tab_style(
    style     = cell_fill(color = "#FFEBEE"),
    locations = cells_body(rows = bad_rows)
  ) |>
  tab_style(
    style     = cell_text(weight = "bold", color = "#C62828"),
    locations = cells_body(columns = c(def_ppa, rank), rows = bad_rows)
  ) |>

  # -- Lynn years: the exception ---------------------------------------------
  tab_style(
    style     = cell_fill(color = "#E8F5E9"),
    locations = cells_body(rows = good_rows)
  ) |>
  tab_style(
    style     = cell_text(weight = "bold", color = "#2E7D32"),
    locations = cells_body(columns = c(def_ppa, rank), rows = good_rows)
  ) |>

  # -- Current season: bold the whole row ------------------------------------
  tab_style(
    style     = cell_text(weight = "bold"),
    locations = cells_body(columns = c(season, dc), rows = row_2026)
  ) |>

  cols_align(align = "center", columns = c(season, def_ppa, rank)) |>
  cols_align(align = "left",   columns = dc) |>

  cols_width(
    season  ~ px(80),
    dc      ~ px(190),
    def_ppa ~ px(100),
    rank    ~ px(100)
  )

# --- Save as PNG ------------------------------------------------------------

output_dir <- "graphics"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

gtsave(tbl, filename = file.path(output_dir, "cfb_week4_usc_dc_table.png"), vwidth = 520)

cli::cli_alert_success("Table saved to {.file {file.path(output_dir, 'cfb_week4_usc_dc_table.png')}}")

# week4_wrap_week5_storylines_coach_path_table.R
# Offensive-path vs. defensive-path head coaches, 2021-2025, for "That's Offensive!"
# Section: "A Beautiful Mind"
# Output: graphics/week4_wrap_week5_storylines/candidate_5.png
#
# Data: figures as stated in the article (Steve's nflverse/nflreadr analysis).
# Coaches classified by the side of the ball they coached before their first
# head coaching job; regular season plus playoffs; interim coaches assigned
# game by game.
#
# Packages: gt, gtExtras, dplyr, tibble

library(gt)
library(gtExtras)
library(dplyr)
library(tibble)

# --- Data -------------------------------------------------------------------

coach_path <- tibble::tribble(
  ~metric,                 ~offense, ~defense,
  "Win %",                 "53%",    "47%",
  "Made playoffs",         "49%",    "35%",
  "Top-10 offense",        "44%",    "15%",
  "Top-10 defense",        "33%",    "29%",
  "Average defense rank",  "16.4",   "16.4"
)

win_rows     <- which(coach_path$metric %in% c("Win %", "Made playoffs"))
off_row      <- which(coach_path$metric == "Top-10 offense")
def_row      <- which(coach_path$metric == "Top-10 defense")
def_rank_row <- which(coach_path$metric == "Average defense rank")

# --- Build table ------------------------------------------------------------

tbl <- coach_path |>
  gt() |>

  cols_label(
    metric  = "",
    offense = md("**Offensive-path**<br><span style='font-weight:normal;color:#666;'>head coaches</span>"),
    defense = md("**Defensive-path**<br><span style='font-weight:normal;color:#666;'>head coaches</span>")
  ) |>

  tab_header(
    title    = md("**Hire a Defensive Coach, Get... the Same Defense**"),
    subtitle = md("NFL head coaches by the side of the ball they coached before their first head job, 2021–2025")
  ) |>

  tab_footnote(
    footnote  = "Lower is better.",
    locations = cells_body(columns = metric, rows = def_rank_row)
  ) |>
  tab_footnote(
    footnote  = "2026 through Week 4: offensive-path coaches are 21-6 head-to-head against defensive-path coaches.",
    locations = cells_column_labels(columns = offense)
  ) |>

  tab_source_note(
    source_note = md("**TheMerrittocracy** · Data via nflverse/nflreadr. Regular season plus playoffs; interim coaches assigned game by game.")
  ) |>

  tab_options(
    table.font.size                    = px(14),
    heading.title.font.size            = px(18),
    heading.subtitle.font.size         = px(12),
    column_labels.font.size            = px(13),
    table.width                        = pct(100),
    data_row.padding                   = px(8),
    heading.padding                    = px(8),
    source_notes.font.size             = px(10),
    footnotes.font.size                = px(10),
    table.border.top.color             = "#222222",
    heading.border.bottom.color        = "#222222",
    column_labels.border.bottom.color  = "#666666",
    table_body.border.bottom.color     = "#222222"
  ) |>

  tab_style(
    style     = cell_text(weight = "bold", size = px(13)),
    locations = cells_body(columns = metric)
  ) |>

  # -- Win % and playoffs: offensive coaches ahead ---------------------------
  tab_style(
    style     = cell_text(weight = "bold", color = "#2E7D32"),
    locations = cells_body(columns = offense, rows = win_rows)
  ) |>

  # -- Top-10 offense: the biggest gap ---------------------------------------
  tab_style(
    style     = cell_fill(color = "#E3F2FD"),
    locations = cells_body(rows = off_row)
  ) |>
  tab_style(
    style     = cell_text(weight = "bold", color = "#1565C0"),
    locations = cells_body(columns = offense, rows = off_row)
  ) |>

  # -- Top-10 defense: the surprise ------------------------------------------
  tab_style(
    style     = list(cell_fill(color = "#FFF8E1"), cell_text(weight = "bold")),
    locations = cells_body(rows = def_row)
  ) |>

  # -- Average defense rank: dead even ---------------------------------------
  tab_style(
    style     = list(cell_fill(color = "#F5F5F5"), cell_text(style = "italic")),
    locations = cells_body(rows = def_rank_row)
  ) |>

  cols_align(align = "center", columns = c(offense, defense)) |>
  cols_align(align = "left",   columns = metric) |>

  cols_width(
    metric  ~ px(200),
    offense ~ px(170),
    defense ~ px(170)
  )

# --- Save as PNG ------------------------------------------------------------

output_dir <- "graphics/week4_wrap_week5_storylines"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

gtsave(tbl, filename = file.path(output_dir, "candidate_5.png"), vwidth = 600)

cli::cli_alert_success("Table saved to {.file {file.path(output_dir, 'candidate_5.png')}}")

# week4_wrap_week5_storylines_table.R
# Candidate 1 (table, gt): start chance vs. actual fantasy points, Weeks 1-4,
# for the five named players the "That's Offensive!" draft hangs its
# Jacksonville and Atlanta sections on. Companion graphic for
# "That's Offensive!" (nfl-season, 2026-10-11).
#
# Data: boxscore-prophet/output/10d_receipts_2026_w0{1..4}.csv
#   (start_pct, boom_pct, fp_actual, dnp -- Boxscore Prophet's pre-kickoff
#   start/boom chances and post-game actual PPR points)
#
# Packages: gt, gtExtras, dplyr, tibble, readr
# Output: graphics/week4_wrap_week5_storylines/candidate_1.png

library(gt)
library(gtExtras)
library(dplyr)
library(tibble)
library(readr)

repo_out <- "/Users/stephenmerritt/boxscore-prophet/output"

weeks <- c("w01", "w02", "w03", "w04")

players <- tibble::tribble(
  ~player_name,         ~team, ~tag,
  "Trevor Lawrence",    "JAX", "Jaguars QB",
  "Bijan Robinson",     "ATL", "Falcons RB",
  "Drake London",       "ATL", "Falcons WR",
  "Cooper Rush",        "ATL", "Falcons QB (Wk 1-2)",
  "Michael Penix Jr.",  "ATL", "Falcons QB (Wk 3-4)"
)

read_week <- function(w) {
  readr::read_csv(file.path(repo_out, paste0("10d_receipts_2026_", w, ".csv")),
                   show_col_types = FALSE) |>
    mutate(week = toupper(w))
}

raw <- bind_rows(lapply(weeks, read_week))

dat <- raw |>
  inner_join(players, by = "player_name") |>
  filter(posteam == team) |>
  select(player_name, tag, week, start_pct, fp_actual, dnp, hit_start) |>
  mutate(
    week = sub("W0", "Week ", week),
    outcome = case_when(
      dnp ~ "DNP",
      is.na(hit_start) ~ "DNP",
      hit_start ~ "Cleared",
      !hit_start ~ "Missed"
    ),
    fp_disp = ifelse(dnp, NA_real_, fp_actual)
  )

wide <- dat |>
  select(player_name, tag, week, start_pct, fp_disp, outcome) |>
  tidyr::pivot_wider(
    names_from = week,
    values_from = c(start_pct, fp_disp, outcome),
    names_glue = "{week}_{.value}"
  )

# Order players: Lawrence, Bijan, London, Rush, Penix -- matches article order
player_order <- players$player_name
wide <- wide |>
  mutate(player_name = factor(player_name, levels = player_order)) |>
  arrange(player_name) |>
  mutate(player_name = as.character(player_name))

tbl <- wide |>
  select(
    player_name, tag,
    `Week 1_start_pct`, `Week 1_fp_disp`,
    `Week 2_start_pct`, `Week 2_fp_disp`,
    `Week 3_start_pct`, `Week 3_fp_disp`,
    `Week 4_start_pct`, `Week 4_fp_disp`
  ) |>
  gt() |>

  tab_header(
    title    = md("**Start Chance vs. Actual, Weeks 1-4**"),
    subtitle = md("Boxscore Prophet's pre-kickoff start chance next to the PPR points each player actually scored")
  ) |>

  cols_label(
    player_name = "Player",
    tag = "Role",
    `Week 1_start_pct` = "Start %",
    `Week 1_fp_disp` = "PPR",
    `Week 2_start_pct` = "Start %",
    `Week 2_fp_disp` = "PPR",
    `Week 3_start_pct` = "Start %",
    `Week 3_fp_disp` = "PPR",
    `Week 4_start_pct` = "Start %",
    `Week 4_fp_disp` = "PPR"
  ) |>

  tab_spanner(label = "Week 1", columns = c(`Week 1_start_pct`, `Week 1_fp_disp`)) |>
  tab_spanner(label = "Week 2", columns = c(`Week 2_start_pct`, `Week 2_fp_disp`)) |>
  tab_spanner(label = "Week 3", columns = c(`Week 3_start_pct`, `Week 3_fp_disp`)) |>
  tab_spanner(label = "Week 4", columns = c(`Week 4_start_pct`, `Week 4_fp_disp`)) |>

  fmt_number(columns = ends_with("fp_disp"), decimals = 1) |>
  fmt_missing(columns = ends_with("fp_disp"), missing_text = "DNP") |>
  fmt_percent(columns = ends_with("start_pct"), scale_values = FALSE, decimals = 0) |>

  sub_missing(columns = ends_with("start_pct"), missing_text = "--") |>

  tab_footnote(
    footnote = "Benched after Week 2, in favor of Michael Penix Jr.",
    locations = cells_body(columns = player_name, rows = player_name == "Cooper Rush")
  ) |>
  tab_footnote(
    footnote = "Did not play until Week 3, after Rush and Jack Strand combined for five interceptions over Weeks 1-2.",
    locations = cells_body(columns = player_name, rows = player_name == "Michael Penix Jr.")
  ) |>

  tab_source_note(
    source_note = md("**TheMerrittocracy** · Start chance and actual PPR via Boxscore Prophet pre-kickoff receipts (`10d_receipts_2026_w01-w04.csv`)")
  ) |>

  tab_options(
    table.font.size             = px(13),
    heading.title.font.size     = px(18),
    heading.subtitle.font.size  = px(12),
    column_labels.font.size     = px(12),
    table.width                 = pct(100),
    data_row.padding            = px(6),
    heading.padding             = px(8),
    source_notes.font.size      = px(10),
    footnotes.font.size         = px(10),
    table.border.top.color      = "#222222",
    heading.border.bottom.color = "#222222",
    column_labels.border.bottom.color = "#666666",
    table_body.border.bottom.color    = "#222222"
  ) |>

  tab_style(style = cell_text(weight = "bold"), locations = cells_column_labels()) |>
  tab_style(style = cell_text(weight = "bold"), locations = cells_column_spanners()) |>
  tab_style(style = cell_text(weight = "bold"), locations = cells_body(columns = player_name)) |>
  tab_style(style = cell_text(color = "#666666", size = px(11)), locations = cells_body(columns = tag)) |>

  cols_align(align = "center", columns = ends_with("start_pct")) |>
  cols_align(align = "center", columns = ends_with("fp_disp")) |>
  cols_align(align = "left", columns = c(player_name, tag)) |>

  cols_width(
    player_name ~ px(150),
    tag ~ px(150),
    ends_with("start_pct") ~ px(75),
    ends_with("fp_disp") ~ px(65)
  )

output_dir <- "graphics/week4_wrap_week5_storylines"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

gtsave(tbl, filename = file.path(output_dir, "candidate_1.png"), vwidth = 980)

cli::cli_alert_success("Table saved to {.file {file.path(output_dir, 'candidate_1.png')}}")

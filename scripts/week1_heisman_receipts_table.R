# week1_heisman_receipts_table.R
# Week 1 Heisman stat-line table for the "Same Stat Line, Someone Else's
# Defense" post -- same box scores, ranked by how good the opponent's pass
# defense actually was in 2025.
# Output: graphics/week1_heisman_receipts_table.png
#
# Packages: gt, gtExtras, dplyr, readr
# Install if needed:
#   install.packages(c("gt", "gtExtras", "dplyr", "readr"))

library(gt)
library(gtExtras)
library(dplyr)
library(readr)

# --- Data --------------------------------------------------------------

stat_lines <- read_csv(
  "data/week1_heisman_receipts_stat_lines.csv",
  show_col_types = FALSE
)

ordinal <- function(n) {
  suffix <- dplyr::case_when(
    n %% 100 %in% 11:13 ~ "th",
    n %% 10 == 1        ~ "st",
    n %% 10 == 2         ~ "nd",
    n %% 10 == 3         ~ "rd",
    TRUE                 ~ "th"
  )
  paste0(n, suffix)
}

tbl_data <- stat_lines |>
  arrange(opp_pass_d_rank_2025) |>
  mutate(
    player_cell   = paste0(player, "<br><span style='font-weight:normal;color:#666;'>", team, "</span>"),
    comp_att      = paste0(comp, "-", att),
    td_cell       = paste0(pass_td, " (", rush_td, ")"),
    opp_cell      = paste0(opponent, "<br><span style='font-weight:normal;color:#666;'>", ordinal(opp_pass_d_rank_2025), " of 136</span>")
  ) |>
  select(player_cell, opp_cell, comp_att, pass_yds, td_cell)

# --- Row indices for highlighting ---------------------------------------

tested_rows  <- which(stat_lines |> arrange(opp_pass_d_rank_2025) |> pull(player) %in% c("Dante Moore", "Trinidad Chambliss"))
padded_row   <- which(stat_lines |> arrange(opp_pass_d_rank_2025) |> pull(player) == "Darian Mensah")

# --- Build table ----------------------------------------------------------

tbl <- tbl_data |>
  gt() |>

  cols_label(
    player_cell = "Player",
    opp_cell    = "Week 1 opponent",
    comp_att    = "Comp-Att",
    pass_yds    = "Pass yds",
    td_cell     = "Pass TD (Rush TD)"
  ) |>

  fmt_markdown(columns = c(player_cell, opp_cell)) |>

  tab_header(
    title    = md("**They Are Who We Thought They Were**"),
    subtitle = md("Week 1 Heisman box scores, ranked by how good the opponent's pass defense actually was in 2025")
  ) |>

  tab_source_note(
    source_note = md("**TheMerrittocracy** · Box scores via ESPN and CFB Reference; opponent pass defense ranked out of 136 FBS teams by 2025 yards allowed per game")
  ) |>

  tab_options(
    table.font.size                    = px(13),
    heading.title.font.size            = px(18),
    heading.subtitle.font.size         = px(12),
    column_labels.font.size            = px(12),
    table.width                        = pct(100),
    data_row.padding                   = px(6),
    heading.padding                    = px(8),
    source_notes.font.size             = px(10),
    table.border.top.color             = "#222222",
    heading.border.bottom.color        = "#222222",
    column_labels.border.bottom.color  = "#666666",
    table_body.border.bottom.color     = "#222222"
  ) |>

  tab_style(
    style     = cell_text(weight = "bold", size = px(12)),
    locations = cells_body(columns = player_cell)
  ) |>

  # -- Actually tested: Moore and Chambliss, top of the sort by design ----
  tab_style(
    style     = list(cell_fill(color = "#E8F5E9"), cell_text(weight = "bold")),
    locations = cells_body(rows = tested_rows)
  ) |>

  # -- Padded stat: Mensah vs. the country's worst pass defense -----------
  tab_style(
    style     = list(cell_fill(color = "#FFEBEE"), cell_text(color = "#C62828")),
    locations = cells_body(rows = padded_row)
  ) |>

  cols_align(align = "center", columns = c(comp_att, pass_yds, td_cell)) |>
  cols_align(align = "left",   columns = c(player_cell, opp_cell)) |>

  cols_width(
    player_cell ~ px(160),
    opp_cell    ~ px(160),
    comp_att    ~ px(90),
    pass_yds    ~ px(90),
    td_cell     ~ px(130)
  )

# --- Save as PNG ------------------------------------------------------------

output_dir <- "graphics"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

gtsave(tbl, filename = file.path(output_dir, "week1_heisman_receipts_table.png"), vwidth = 660)

cli::cli_alert_success("Table saved to {.file {file.path(output_dir, 'week1_heisman_receipts_table.png')}}")

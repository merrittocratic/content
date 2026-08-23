# ============================================================================
# heisman_candidates_table.R
#
# The candidate table for "The Discovery Channel" (cfb-season, 2026-08-23):
# what each 2026 Heisman candidate must climb to reach a No. 3 finish, priced
# against both rank-3 bars, plus the team wins each needs to reach 11-1.
#
# Follows the house table convention (light gt, not the dark chart palette),
# with gtExtras for the stacked name/team cell and row highlighting.
#
# Data: ../nfl-draft-model/output/heisman_handoff/candidates_2026_targets.csv
#
# Two things this script derives rather than trusts:
#   * growth vs the 2025 field is NOT in the CSV -- computed here from
#     BAR_2025, which is hand-carried from BRIDGE_PROMPT.md.
#   * wins needed runs to 11-1 on a twelve-game regular season, and two rows
#     use a different team's record than the stat line came from (see
#     WINS_REC_OVERRIDE). Those two carry gt footnotes.
#
# Output: content/graphics/heisman_candidates_table.png
# ============================================================================

library(gt)
library(gtExtras)
library(dplyr)
library(readr)

in_path  <- "../nfl-draft-model/output/heisman_handoff/candidates_2026_targets.csv"
out_path <- "graphics/heisman_candidates_table.png"

TARGET_WINS <- 11    # 11-1 on a twelve-game regular season
DROP        <- c("Dante Moore")           # cut from the article
BAR_2025    <- c(QB = 556.0, WR = 174.1)  # rank-3 production, 2025 field only

# Rows whose team context for 2026 differs from the team the stat line came
# from. Value is the record the wins target should actually be measured off.
WINS_REC_OVERRIDE <- c(
  "Mateer (2024, healthy)" = "10-2",   # Oklahoma 2025, not Washington State
  "Cam Coleman"            = "9-3"     # Texas 2025, not Auburn
)

# --- Data --------------------------------------------------------------------
raw <- read_csv(in_path, show_col_types = FALSE)

dat <- raw |>
  filter(!player %in% DROP) |>
  mutate(
    production   = baseline_yards / 10 + baseline_td * 6,
    growth_5yr   = growth_needed_pct,
    growth_2025  = 100 * (BAR_2025[position] / production - 1),
    wins_rec     = coalesce(unname(WINS_REC_OVERRIDE[candidate]),
                            baseline_team_rec),
    wins_now     = as.integer(sub("-.*$", "", wins_rec)),
    wins_needed  = pmax(0L, TARGET_WINS - wins_now),
    name_disp    = case_when(
      candidate == "Mateer (2024, healthy)" ~ "John Mateer",
      candidate == "Mateer (2025, hurt)"    ~ "John Mateer",
      TRUE                                  ~ player
    ),
    context = case_when(
      candidate == "Mateer (2024, healthy)" ~ "2024 Washington St. (healthy)",
      candidate == "Mateer (2025, hurt)"    ~ "2025 Oklahoma (hurt)",
      TRUE ~ sprintf("%s, %s", baseline_team, baseline_team_rec)
    ),
    stat_line = sprintf("%s yd / %d TD",
                        formatC(baseline_yards, big.mark = ",", format = "d"),
                        baseline_td),
    rank_disp = sprintf("%d of %d", rank_vs_2025_field, pool_2025_field),
    is_cf     = candidate == "Mateer (2024, healthy)",
    name_cell = sprintf(
      paste0("<div style='font-weight:700;font-size:13.5px;%s'>%s</div>",
             "<div style='color:#8A8A8A;font-size:10.5px;font-weight:600;%s'>%s</div>"),
      if_else(is_cf, "font-style:italic;", ""), name_disp,
      if_else(is_cf, "font-style:italic;", ""), context)
  ) |>
  arrange(position, rank_vs_2025_field) |>
  arrange(rank_vs_2025_field) |>
  select(name_cell, position, stat_line, rank_disp,
         growth_5yr, growth_2025, wins_needed, candidate)

stopifnot(nrow(dat) == 7, all(DROP %in% raw$player),
          all(names(WINS_REC_OVERRIDE) %in% raw$candidate))

# footnote anchors, found by name so row order can change safely
row_mateer24 <- which(dat$candidate == "Mateer (2024, healthy)")
row_coleman  <- which(dat$candidate == "Cam Coleman")
row_carr     <- which(dat$candidate == "C.J. Carr")
row_mateer25 <- which(dat$candidate == "Mateer (2025, hurt)")

# growth reads as difficulty: green is an easy ask, red is a hard one
growth_pal <- scales::col_numeric(
  palette = c("#E8F5E9", "#FFFDE7", "#FFEBEE"),
  domain  = c(-20, 90)
)

fmt_growth <- function(x) {
  ifelse(x <= 0, "already clear", sprintf("+%.1f%%", x))
}

# --- Table -------------------------------------------------------------------
MATEER24 <- "Mateer (2024, healthy)"

tbl <- dat |>
  gt() |>
  cols_hide(columns = candidate) |>
  fmt_markdown(columns = name_cell) |>
  # The 2024 line is a counterfactual, not a member of the 2025 field. It gets
  # its own group so the different season is structural, not just a caption.
  tab_row_group(
    label = md("**IF HE'S HEALTHY** &nbsp;·&nbsp; a 2024 season, scored against the 2025 field"),
    rows  = candidate == MATEER24
  ) |>
  tab_row_group(
    label = md("**THE 2025 FIELD**"),
    rows  = candidate != MATEER24
  ) |>
  row_group_order(groups = c("**THE 2025 FIELD**",
                             "**IF HE'S HEALTHY** &nbsp;·&nbsp; a 2024 season, scored against the 2025 field")) |>
  cols_label(
    name_cell   = "Candidate",
    position    = "Pos",
    stat_line   = "Baseline production",
    rank_disp   = "Rank (pool)",
    growth_5yr  = md("vs 5-yr bar"),
    growth_2025 = md("vs 2025 field"),
    wins_needed = md("Wins needed<br>to 11-1")
  ) |>
  tab_spanner(
    label   = md("**Growth needed to reach No. 3**"),
    columns = c(growth_5yr, growth_2025)
  ) |>
  fmt(columns = c(growth_5yr, growth_2025), fns = fmt_growth) |>
  data_color(columns = c(growth_5yr, growth_2025), fn = growth_pal) |>
  tab_header(
    title    = md("**What Each Name Actually Has to Climb**"),
    subtitle = md(paste(
      "No. 3 is the target because it is the worst any Heisman winner has",
      "finished since 2011. It is priced two ways, because the bar moved."
    ))
  ) |>
  tab_footnote(
    footnote  = "Wins measured off Oklahoma's 2025 record, 10-2, not Washington State's stale 8-4.",
    locations = cells_body(columns = wins_needed, rows = row_mateer24)
  ) |>
  tab_footnote(
    footnote  = "Wins measured off Texas's 2025 record, 9-3, post-transfer, not Auburn's 5-7.",
    locations = cells_body(columns = wins_needed, rows = row_coleman)
  ) |>
  tab_footnote(
    footnote  = paste("The 5-yr bar is the production that held No. 3 across 2021-25",
                      "(QB 645.3, WR 190.9). The 2025 bar is what held it last season",
                      "alone (QB 556.0, WR 174.1) -- rank-3 production fell every year",
                      "but one since 2021."),
    locations = cells_column_spanners()
  ) |>
  gt_highlight_rows(
    rows = c(row_carr, row_mateer25),
    fill = "#EAF3F8", alpha = 1, bold_target_only = TRUE,
    target_col = name_cell
  ) |>
  tab_style(
    style = list(cell_fill(color = "#FFF3E0"), cell_text(style = "italic")),
    locations = cells_body(rows = candidate == MATEER24)
  ) |>
  tab_style(
    style = cell_borders(sides = "left", color = "#E07B39", weight = px(4)),
    locations = cells_body(columns = name_cell, rows = candidate == MATEER24)
  ) |>
  tab_style(
    style = list(cell_fill(color = "#FFF3E0"),
                 cell_text(color = "#8A5100", size = px(11))),
    locations = cells_row_groups(
      groups = "**IF HE'S HEALTHY** &nbsp;·&nbsp; a 2024 season, scored against the 2025 field")
  ) |>
  tab_footnote(
    footnote  = paste("Not a 2025 line. This is Mateer's last fully healthy season,",
                      "2024 at Washington State, scored against the 2025 field so it",
                      "is comparable. His actual 2025 appears in the field above."),
    locations = cells_body(columns = stat_line, rows = candidate == MATEER24)
  ) |>
  tab_source_note(
    source_note = md(paste(
      "**TheMerrittocracy** · Production index = total yards / 10 + 6 per",
      "touchdown, ranked within position. Power 4, regular season only.",
      "Source: cfbfastR / College Football Data API."
    ))
  ) |>
  tab_options(
    table.font.size                   = px(13),
    heading.title.font.size           = px(19),
    heading.subtitle.font.size        = px(12),
    column_labels.font.size           = px(12),
    table.width                       = pct(100),
    data_row.padding                  = px(7),
    heading.padding                   = px(8),
    source_notes.font.size            = px(10),
    footnotes.font.size               = px(10),
    row_group.font.size               = px(11),
    row_group.padding                 = px(5),
    table.border.top.color            = "#222222",
    heading.border.bottom.color       = "#222222",
    column_labels.border.bottom.color = "#666666",
    table_body.border.bottom.color    = "#222222"
  ) |>
  gt_add_divider(columns = rank_disp, color = "#DDDDDD", weight = px(1)) |>
  gt_add_divider(columns = growth_2025, color = "#DDDDDD", weight = px(1)) |>
  cols_align(align = "center",
             columns = c(position, stat_line, rank_disp,
                         growth_5yr, growth_2025, wins_needed)) |>
  cols_align(align = "left", columns = name_cell) |>
  cols_width(
    name_cell   ~ px(200),
    position    ~ px(52),
    stat_line   ~ px(130),
    rank_disp   ~ px(96),
    growth_5yr  ~ px(112),
    growth_2025 ~ px(112),
    wins_needed ~ px(96)
  )

if (!dir.exists("graphics")) dir.create("graphics", recursive = TRUE)
gtsave(tbl, filename = out_path, vwidth = 860)
cat("wrote", out_path, "\n")

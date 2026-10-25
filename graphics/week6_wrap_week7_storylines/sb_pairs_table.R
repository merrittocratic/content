# sb_pairs_table.R
# Candidate 5 for "Defense Wins Championships. Right?" (week6_wrap_week7_storylines),
# section "Ludicrous Speed": the five Super Bowl pairs since 2002 with the
# highest average regular-season game totals, and what the Super Bowl produced.
# Data: Steve's packet (pair averages, Super Bowl totals, market lines).
# Output: graphics/week6_wrap_week7_storylines/candidate_5.png
# Run from the repo root: Rscript graphics/week6_wrap_week7_storylines/sb_pairs_table.R

library(gt)
library(dplyr)
library(tibble)

# --- Data -------------------------------------------------------------------

pairs <- tibble::tribble(
  ~season, ~matchup,         ~pair_avg, ~sb_total, ~line,
  "2020",  "TB 31, KC 9",    52.6,      40,        55.0,
  "2018",  "NE 13, LA 3",    52.2,      16,        55.5,
  "2013",  "SEA 43, DEN 8",  51.7,      51,        47.0,
  "2011",  "NYG 21, NE 17",  51.5,      38,        53.0,
  "2016",  "NE 34, ATL 28",  51.2,      62,        57.0
) |>
  mutate(diff = sb_total - pair_avg) |>
  arrange(desc(pair_avg))

under_rows <- which(pairs$diff < 0)
over_rows  <- which(pairs$diff > 0)

# --- Build table ------------------------------------------------------------

tbl <- pairs |>
  gt() |>

  cols_label(
    season    = "Season",
    matchup   = "Super Bowl",
    pair_avg  = "Pair avg game total",
    sb_total  = "SB total",
    line      = "Line",
    diff      = "SB minus avg"
  ) |>

  fmt_number(columns = c(pair_avg, line), decimals = 1) |>
  fmt_number(columns = sb_total, decimals = 0) |>
  fmt_number(columns = diff, decimals = 1, force_sign = TRUE) |>

  tab_header(
    title    = md("**The Highest-Scoring Super Bowl Pairs Mostly Came Up Short**"),
    subtitle = md("Since 2002, the five matchups with the highest average regular-season game totals. Four finished under.")
  ) |>

  tab_source_note(
    source_note = md("**TheMerrittocracy** · Pair avg = average total points in the two teams' regular-season games. Line = the market's closing total. Game results via nflverse/nflreadr.")
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
    table.border.top.color             = "#222222",
    heading.border.bottom.color        = "#222222",
    column_labels.border.bottom.color  = "#666666",
    table_body.border.bottom.color     = "#222222"
  ) |>

  tab_style(
    style     = cell_text(weight = "bold"),
    locations = list(cells_column_labels(), cells_body(columns = matchup))
  ) |>

  # -- Red where the Super Bowl came in under the pair average, green over ---
  tab_style(
    style     = list(cell_fill(color = "#FFEBEE"), cell_text(weight = "bold", color = "#C62828")),
    locations = cells_body(columns = diff, rows = under_rows)
  ) |>
  tab_style(
    style     = list(cell_fill(color = "#E8F5E9"), cell_text(weight = "bold", color = "#2E7D32")),
    locations = cells_body(columns = diff, rows = over_rows)
  ) |>

  cols_align(align = "center", columns = c(season, pair_avg, sb_total, line, diff)) |>
  cols_align(align = "left",   columns = matchup) |>

  cols_width(
    season   ~ px(70),
    matchup  ~ px(150),
    pair_avg ~ px(140),
    sb_total ~ px(90),
    line     ~ px(80),
    diff     ~ px(120)
  )

# --- Save as PNG ------------------------------------------------------------

out_dir <- "graphics/week6_wrap_week7_storylines"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

gtsave(tbl, filename = file.path(out_dir, "candidate_5.png"), vwidth = 760)

cat("wrote", file.path(out_dir, "candidate_5.png"), "\n")

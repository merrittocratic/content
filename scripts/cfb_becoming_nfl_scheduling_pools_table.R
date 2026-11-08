# cfb_becoming_nfl_scheduling_pools_table.R
# Talent-matched scheduling pools for the "You Must Choose. But Choose Wisely."
# section of draft/cfb_becoming_nfl.md
# Output: graphics/cfb_becoming_nfl/scheduling_pools_table.png
#
# Data: data/cfb_scheduling/pools_2026.csv and nonconf_games.csv, built by
# scripts/cfb_scheduling_parity.py from CFBD (247 talent composite, games, lines).
# Pools: the 12 power-conference teams closest in 2022-2026 average talent,
# outside the team's 2026 conference.

library(gt)
library(dplyr)
library(tibble)

pools <- read.csv(file.path("data", "cfb_scheduling", "pools_2026.csv"))

pool_text <- function(t) {
  paste(pools$opponent[pools$team == t], collapse = ", ")
}
talent_of <- function(t) {
  sprintf("%.0f", pools$talent5yr[pools$team == t][1])
}

# 2026 power-conference non-conference game for each featured team
# (spread from the team's side, median across books; result from the team's side)
rows <- tribble(
  ~team,            ~conf,     ~game,                        ~spread,  ~result,   ~in_pool, ~grp,
  "Ohio State",     "Big Ten", "at Texas",                   "+2.25",  "L 23-24", "Yes",    "in",
  "LSU",            "SEC",     "vs. Clemson",                "-10",    "W 51-10", "Yes",    "in",
  "Kentucky",       "SEC",     "vs. Louisville (rivalry)",   "--",     "Nov.",    "No",     "out",
  "Indiana",        "Big Ten", "None scheduled",             "--",     "--",      "--",     "out",
  "Stanford",       "ACC",     "at Notre Dame",              "+40",    "L 7-58",  "No",     "out",
  "Michigan State", "Big Ten", "at Notre Dame",              "+28.75", "L 10-27", "No",     "out"
) |>
  mutate(
    team_cell = sprintf(
      "**%s**<br><span style='color:#666666;font-size:11px;'>%s \u00b7 talent %s</span>",
      team, conf, sapply(team, talent_of)),
    pool = sapply(team, pool_text),
    grp = factor(grp, levels = c("in", "out"),
                 labels = c("This year's game came from the pool",
                            "This year's game didn't, or there wasn't one"))
  ) |>
  select(grp, team_cell, pool, game, spread, result, in_pool)

in_rows  <- which(rows$in_pool == "Yes")
out_rows <- which(rows$in_pool == "No")

tbl <- rows |>
  gt(groupname_col = "grp") |>
  fmt_markdown(columns = team_cell) |>
  cols_label(
    team_cell = "",
    pool      = md("**Talent pool**<br><span style='font-weight:normal;color:#666;'>12 closest peers, closest first</span>"),
    game      = md("**2026 power**<br>non-con game"),
    spread    = "Spread",
    result    = "Result",
    in_pool   = md("**In**<br>pool?")
  ) |>
  tab_header(
    title    = md("**You Must Choose. But Choose Wisely.**"),
    subtitle = md("Each power-conference team's scheduling pool: the 12 closest teams outside its conference by average 247 talent composite, 2022-2026")
  ) |>
  tab_footnote(
    footnote  = "Since 2021, excluding Notre Dame, favorites won 61% of power-conference non-conference games between pool teams (83 games) and 73% of those outside a pool (100 games). NFL favorites win about 64%.",
    locations = cells_column_labels(columns = in_pool)
  ) |>
  tab_footnote(
    footnote  = "Closing spread from the team's side, median across sportsbooks. Kentucky-Louisville is a rivalry game that stays on top of the pool game under the proposal.",
    locations = cells_column_labels(columns = spread)
  ) |>
  tab_source_note(
    source_note = md("**TheMerrittocracy** \u00b7 Data via CollegeFootballData.com and 247Sports talent composite")
  ) |>
  tab_options(
    table.font.size                   = px(13),
    heading.title.font.size           = px(18),
    heading.subtitle.font.size        = px(12),
    column_labels.font.size           = px(12),
    row_group.font.size               = px(12),
    row_group.font.weight             = "bold",
    row_group.background.color        = "#F5F5F5",
    table.width                       = pct(100),
    data_row.padding                  = px(7),
    heading.padding                   = px(8),
    source_notes.font.size            = px(10),
    footnotes.font.size               = px(10),
    table.border.top.color            = "#222222",
    heading.border.bottom.color       = "#222222",
    column_labels.border.bottom.color = "#666666",
    table_body.border.bottom.color    = "#222222"
  ) |>
  tab_style(
    style     = cell_text(size = px(12), color = "#333333"),
    locations = cells_body(columns = pool)
  ) |>
  tab_style(
    style     = list(cell_fill(color = "#E3F2FD"), cell_text(color = "#3A7CA5", weight = "bold")),
    locations = cells_body(columns = in_pool, rows = in_rows)
  ) |>
  tab_style(
    style     = list(cell_fill(color = "#FFEBEE"), cell_text(color = "#C0392B", weight = "bold")),
    locations = cells_body(columns = in_pool, rows = out_rows)
  ) |>
  tab_style(
    style     = cell_fill(color = "#FFF8E1"),
    locations = cells_body(columns = c(game, spread, result),
                           rows = which(rows$spread %in% c("+40", "+28.75")))
  ) |>
  cols_align(align = "left",   columns = c(team_cell, pool, game)) |>
  cols_align(align = "center", columns = c(spread, result, in_pool)) |>
  cols_width(
    team_cell ~ px(150),
    pool      ~ px(330),
    game      ~ px(150),
    spread    ~ px(70),
    result    ~ px(70),
    in_pool   ~ px(60)
  )

output_dir <- file.path("graphics", "cfb_becoming_nfl")
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)
out <- file.path(output_dir, "scheduling_pools_table.png")
gtsave(tbl, filename = out, vwidth = 900)
message("Table saved to ", out)

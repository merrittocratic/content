# cfp_committee_usual_suspects_board_table.R
# Expected result (written before building): Kentucky (CFP 16 vs SP+ 42) and Ohio
# State (CFP 14 vs SP+ 4) are the big gaps in opposite directions; Alabama, Texas
# and Kentucky are the rows the article is about.
# Output: graphics/cfp_committee_usual_suspects/board_table.png

library(gt)
library(dplyr)

out_path <- "graphics/cfp_committee_usual_suspects/board_table.png"
dir.create(dirname(out_path), recursive = TRUE, showWarnings = FALSE)

board <- tibble::tribble(
  ~cfp, ~ap, ~team,         ~rec,   ~sp, ~fpi, ~sor, ~epa,
  1,    1,  "Georgia",      "9-1",   1,   1,    4,    2,
  2,    2,  "Utah",         "10-0", 10,  12,    1,    6,
  3,    7,  "Alabama",      "8-2",   6,   4,    6,   14,
  4,    4,  "UCLA",         "10-0", 12,  25,    2,    7,
  5,    8,  "Texas",        "8-2",   8,   6,    5,   35,
  6,    3,  "Notre Dame",   "9-1",   2,   2,    7,    3,
  7,    5,  "Miami",        "9-1",   3,   3,    3,    9,
  8,    6,  "Indiana",      "9-1",   5,   8,    8,   10,
  9,    9,  "Tennessee",    "8-2",  11,  11,   10,   19,
  10,  12,  "BYU",          "8-2",  15,  15,   13,   29,
  11,  10,  "Wake Forest",  "9-1",   7,  10,    9,    1,
  12,  11,  "Texas Tech",   "9-1",  13,  14,   11,   31,
  13,  14,  "Oregon",       "7-3",  14,   9,   16,   26,
  14,  16,  "Ohio State",   "7-3",   4,   5,   15,   15,
  15,  13,  "Iowa",         "8-2",  16,  17,   18,   20,
  16,  17,  "Kentucky",     "7-3",  42,  34,   14,   63
)

hl  <- which(board$team %in% c("Alabama", "Texas", "Kentucky"))
big <- which(abs(board$cfp - board$sp) >= 5)   # CFP rank vs SP+ rank gap of 5+

tbl <- board |>
  gt() |>
  cols_label(cfp = "CFP", ap = "AP", team = "Team", rec = "Record",
             sp = "SP+", fpi = "FPI", sor = "SOR", epa = "Net EPA") |>
  tab_spanner(label = "Rank (of 138 FBS)", columns = c(sp, fpi, sor, epa)) |>
  tab_header(
    title    = md("**The Committee's Top 16, Against The Computers**"),
    subtitle = md("CFP ranking of Nov. 17. Shaded teams are the ones in question; bold red marks a CFP-vs-SP+ gap of 5+ spots")
  ) |>
  tab_source_note(md("**TheMerrittocracy** · Data via cfbfastR / College Football Data API. SP+ and FPI are opponent-adjusted; SOR is ESPN's strength of record; net EPA is offense minus defense per play (garbage time excluded, not opponent-adjusted).")) |>
  tab_options(
    table.font.size = px(13), heading.title.font.size = px(18),
    heading.subtitle.font.size = px(11), column_labels.font.size = px(12),
    data_row.padding = px(5), source_notes.font.size = px(9),
    table.border.top.color = "#222222", heading.border.bottom.color = "#222222",
    column_labels.border.bottom.color = "#666666", table_body.border.bottom.color = "#222222"
  ) |>
  cols_align("center", columns = -team) |>
  cols_align("left", columns = team) |>
  tab_style(cell_text(weight = "bold"), cells_body(columns = c(cfp, team))) |>
  tab_style(cell_fill("#FFF3E0"), cells_body(rows = hl)) |>
  tab_style(cell_text(color = "#C0392B", weight = "bold"),
            cells_body(columns = sp, rows = big)) |>
  cols_width(cfp ~ px(50), ap ~ px(50), team ~ px(150), rec ~ px(70),
             sp ~ px(60), fpi ~ px(60), sor ~ px(60), epa ~ px(80))

gtsave(tbl, out_path, vwidth = 640)
cat("wrote", out_path, "\n")

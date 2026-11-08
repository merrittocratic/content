# cfb_becoming_nfl_ap_vs_computers_table.R
# CFP and AP rank vs. six-measure computer consensus for the
# "Toto, I've A Feeling We're Not In Kansas Anymore" post (draft/cfb_becoming_nfl.md)
# Output: graphics/cfb_becoming_nfl/ap_vs_computers_table.png
#
# Data: CFP committee rankings (Nov. 3 release); CFBD (AP poll, SRS, Elo, FPI, SP+, strength of record) and EPA per play
# from public play-by-play, as delivered in the 2026 data packet (through Week 9).
# Computer consensus = median rank across point differential, SRS, Elo, FPI,
# SP+ and EPA per play, out of 138 FBS teams.

library(gt)
library(dplyr)
library(tibble)

# --- Data -------------------------------------------------------------------

teams <- tribble(
  ~team,         ~record, ~cfp, ~ap, ~consensus, ~sor, ~grp,
  "Kentucky",    "7-1",     6,    8,   36.5,        2,  "poll",
  "New Mexico",  "7-1",    NA,   22,   36.5,       32,  "poll",
  "BYU",         "7-1",     9,    7,   19.5,       12,  "poll",
  "Boise State", "7-1",    25,   20,   32.0,       19,  "poll",
  "Florida",     "5-3",    24,   25,   37.0,       15,  "poll",
  "UCLA",        "8-0",     8,    5,   15.0,        3,  "poll",
  "LSU",         "6-2",    14,   15,    3.5,       16,  "comp",
  "Ohio State",  "6-2",    12,   11,    6.0,        9,  "comp",
  "Arizona",     "6-2",    22,   24,   17.0,       30,  "comp"
) |>
  mutate(
    gap = consensus - cfp,
    grp = factor(grp, levels = c("poll", "comp"),
                 labels = c("The humans like them more: the record is ahead of the team",
                            "The computers like them more: the team is better than its record"))
  ) |>
  arrange(grp, desc(abs(gap)), is.na(gap))

poll_rows <- which(teams$grp == levels(teams$grp)[1])
comp_rows <- which(teams$grp == levels(teams$grp)[2])
ky_row    <- which(teams$team == "Kentucky")
lsu_row   <- which(teams$team == "LSU")

# --- Build table ------------------------------------------------------------

tbl <- teams |>
  gt(groupname_col = "grp") |>
  cols_label(
    team      = "",
    record    = "Record",
    cfp       = md("**CFP**<br>rank"),
    ap        = md("**AP**<br>rank"),
    consensus = md("**Computer**<br>consensus"),
    sor       = md("**Strength**<br>of record"),
    gap       = md("**Gap**<br>(spots)")
  ) |>
  fmt_number(columns = consensus, decimals = 1, drop_trailing_zeros = TRUE) |>
  fmt_number(columns = gap, decimals = 1, drop_trailing_zeros = TRUE,
             force_sign = TRUE) |>
  sub_missing(columns = cfp, missing_text = "NR") |>
  sub_missing(columns = gap, missing_text = "\u2014") |>
  tab_header(
    title    = md("**The Poll Grades The Record. The Computers Grade The Team.**"),
    subtitle = md("Playoff committee and AP poll vs. median computer rank, out of 138 FBS teams, 2026 through Week 9")
  ) |>
  tab_footnote(
    footnote  = "Median rank across point differential, SRS, Elo, FPI, SP+ and EPA per play. SP+ and FPI still carry some preseason weighting.",
    locations = cells_column_labels(columns = consensus)
  ) |>
  tab_footnote(
    footnote  = "How impressive the record is, given who the team played.",
    locations = cells_column_labels(columns = sor)
  ) |>
  tab_footnote(
    footnote  = "Computer consensus minus CFP rank. Positive: the committee ranks the team higher than the computers do. NR: not in the CFP top 25.",
    locations = cells_column_labels(columns = gap)
  ) |>
  tab_footnote(
    footnote  = "First CFP committee rankings, released Nov. 3. AP poll entering Week 10.",
    locations = cells_column_labels(columns = cfp)
  ) |>
  tab_source_note(
    source_note = md("**TheMerrittocracy** \u00b7 Data via CollegeFootballData.com and CollegeFootballPlayoff.com; EPA per play from public play-by-play")
  ) |>
  tab_options(
    table.font.size                   = px(13),
    heading.title.font.size           = px(17),
    heading.subtitle.font.size        = px(12),
    column_labels.font.size           = px(12),
    row_group.font.size               = px(12),
    row_group.font.weight             = "bold",
    row_group.background.color        = "#F5F5F5",
    table.width                       = pct(100),
    data_row.padding                  = px(6),
    heading.padding                   = px(8),
    source_notes.font.size            = px(10),
    footnotes.font.size               = px(10),
    table.border.top.color            = "#222222",
    heading.border.bottom.color       = "#222222",
    column_labels.border.bottom.color = "#666666",
    table_body.border.bottom.color    = "#222222"
  ) |>
  tab_style(
    style     = cell_text(weight = "bold"),
    locations = cells_body(columns = team)
  ) |>
  tab_style(
    style     = list(cell_fill(color = "#FFEBEE"), cell_text(color = "#C0392B", weight = "bold")),
    locations = cells_body(columns = gap, rows = poll_rows)
  ) |>
  tab_style(
    style     = list(cell_fill(color = "#E3F2FD"), cell_text(color = "#3A7CA5", weight = "bold")),
    locations = cells_body(columns = gap, rows = comp_rows)
  ) |>
  tab_style(
    style     = cell_fill(color = "#FFF8E1"),
    locations = cells_body(columns = -gap, rows = c(ky_row, lsu_row))
  ) |>
  cols_align(align = "center", columns = -team) |>
  cols_align(align = "left", columns = team) |>
  cols_width(
    team      ~ px(130),
    record    ~ px(75),
    cfp       ~ px(70),
    ap        ~ px(70),
    consensus ~ px(100),
    sor       ~ px(100),
    gap       ~ px(90)
  )

# --- Save -------------------------------------------------------------------

output_dir <- file.path("graphics", "cfb_becoming_nfl")
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

out <- file.path(output_dir, "ap_vs_computers_table.png")
gtsave(tbl, filename = out, vwidth = 700)
message("Table saved to ", out)
